import gleam/io
import gleam/int
import gleam/erlang
import gleam/float
import gleam/result
import gleam/string
import styles.{Command, DarkRed, Italic, Normal, PlayerName}
import repo/connection
import repo/player.{get_players, save_player}
import enigmas
import gleam/dict
import types/shared_types.{
  type Dragon, type Player, type Session, DragonStats, EnigmaError, EnigmaRec,
  PlayerStats, SessionInfo,
}
import messages

type TurnInfo {
  Turn(
    question: String,
    answer: String,
    turn_number: Int,
    characters: #(Player, Dragon),
  )
}

const enigma_numbers = [
  #(1, "------------- PRIMEIRA -------------"),
  #(2, "------------- SEGUNDA --------------"),
  #(3, "------------- TERCEIRA -------------"),
  #(4, "-------------- QUARTA --------------"),
  #(5, "-------------- QUINTA --------------"),
  #(6, "-------------- SEXTA ---------------"),
  #(7, "-------------- SÉTIMA --------------"),
  #(8, "-------------- OITAVA --------------"),
  #(9, "--------------- NONA ---------------"),
  #(10, "-------------- DÉCIMA --------------"),
]

@external(erlang, "math", "log")
pub fn log(n: Float) -> Float

pub fn main() {
  let _setup_tables = connection.setup_tables()
  messages.initial()

  let _ =
    erlang.get_line(prompt: styles.format_message(
      "<pressione enter para continuar>\n",
      Italic,
      Command,
    ))

  messages.dragon_message("Quem me acorda de meu duradouro sono?")
  |> result.unwrap("")
  |> styles.format_message(Normal, styles.AsciiDragon)
  |> io.println()

  let player = get_player()

  let dragon_stats =
    DragonStats(name: "Alduin", health: 11.0, lucky: 1, attack: 5)

  messages.rules(player)
  start_game(
    turn_number: 1,
    player: player,
    dragon: dragon_stats,
    session: SessionInfo(
      wrong_answers: 0,
      right_answers: 0,
      current_enigma_list: enigmas.enigmas,
    ),
  )
}

pub fn start_game(
  turn_number turn_number: Int,
  player player: Player,
  dragon dragon: Dragon,
  session session: Session,
) -> Nil {
  messages.session_stats(session, player, dragon)

  let _updated_player = get_players()

  let _response =
    erlang.get_line(prompt: "-------------------------------------")

  case turn_number {
    11 -> messages.victory(player)
    _ -> Nil
  }

  case player.health >. 0.0 && dragon.health >. 0.0 {
    True -> {
      let #(enigma, updatred_session) = enigmas.get_enigma(session)

      case enigma {
        EnigmaError(error) -> io.println(error)
        EnigmaRec(question, answer) -> {
          let turn_info =
            Turn(
              question: question,
              answer: answer,
              turn_number: turn_number,
              characters: #(player, dragon),
            )

          turn(turn_info, updatred_session)
        }
      }
    }

    False -> {
      check_health(dragon, player)
    }
  }
}

fn check_health(dragon: Dragon, player: Player) -> Nil {
  case dragon.health {
    0.0 -> messages.victory(player)

    _ -> {
      check_player_health(player)
    }
  }
}

fn check_player_health(player: Player) -> Nil {
  case player.health <=. 0.0 {
    True -> messages.loss(player)

    False -> io.println("Algo deu errado.")
  }
}

fn turn(turn_info: TurnInfo, session: Session) -> Nil {
  let enigma_message =
    dict.from_list(enigma_numbers)
    |> dict.get(turn_info.turn_number)
    |> result.unwrap("FINAL")

  styles.format_message(enigma_message, Normal, DarkRed)
  |> io.println()

  let user_answer =
    erlang.get_line(
      prompt: styles.format_message(turn_info.question, Italic, DarkRed)
      <> player_answer_marker(),
    )
    |> result.unwrap("Error")
    |> string.trim()

  let is_right_answer = turn_info.answer == user_answer

  let #(player, dragon) = turn_info.characters
  let turn_number = turn_info.turn_number + 1

  let lucky_discount =
    int.random(player.lucky)
    |> int.multiply(2)
    |> int.to_float()
    |> log()
    |> float.to_string()
    |> string.pad_right(5, with: "0")
    |> string.slice(at_index: 0, length: 5)
    |> float.parse()
    |> result.unwrap(0.0)

  case is_right_answer {
    True -> {
      let damage = int.to_float(dragon.attack) -. lucky_discount
      let updated_dragon =
        DragonStats(..dragon, health: dragon.health -. damage)

      let message =
        styles.format_message(
          "Dano causado: " <> float.to_string(damage),
          Italic,
          PlayerName,
        )

      io.println(message)

      start_game(
        turn_number: turn_number,
        player: player,
        dragon: updated_dragon,
        session: SessionInfo(
          ..session,
          right_answers: session.right_answers
          + 1,
        ),
      )
    }
    False -> {
      let damage = int.to_float(dragon.attack) -. lucky_discount
      let updated_player =
        PlayerStats(..player, health: player.health -. damage)

      let message =
        styles.format_message(
          "Dano recebido: "
            <> float.to_string(damage)
            <> "\nMais um passo para seu fim...\n",
          Italic,
          DarkRed,
        )

      io.println(message)

      start_game(
        turn_number: turn_number,
        player: updated_player,
        dragon: dragon,
        session: SessionInfo(
          ..session,
          wrong_answers: session.wrong_answers
          + 1,
        ),
      )
    }
  }
}

// dar um jeito de nao chamar charadas repetidas na mesma sessao
fn get_player() -> Player {
  let total_points = 15
  io.println(
    "Você tem "
    <> int.to_string(total_points)
    <> " pontos para me descrever seus principais atributos.",
  )

  let name_message = styles.format_message("Diga-me teu nome:", Italic, DarkRed)

  let name =
    erlang.get_line(prompt: name_message <> player_answer_marker())
    |> result.unwrap("")
    |> string.trim()
    |> styles.format_message(Normal, PlayerName)

  let health = get_attr("Quão resistente você é?", total_points)
  let total_points = total_points - health

  let lucky = get_attr("Quão sortudo você é?", total_points)
  let total_points = total_points - lucky

  let attack = get_attr("Quão forte consegues ferir alguém?", total_points)
  let total_points = total_points - attack

  case total_points {
    total if total == 0 ->
      PlayerStats(
        name: name,
        health: int.to_float(health),
        lucky: lucky,
        attack: attack,
      )

    total if total > 1 -> {
      io.println(styles.format_message(
        "Ora vamos... Você está se subestimando. Vamos tentar de novo.",
        Italic,
        DarkRed,
      ))
      get_player()
    }

    total if total < 0 -> {
      io.println(styles.format_message(
        "Hmmm... Você se valoriza muito, eu entendo. Mas precisamos de algo mais realista.",
        Italic,
        DarkRed,
      ))
      get_player()
    }

    _ -> get_player()
  }
}

fn player_answer_marker() {
  styles.format_message("\n»» ", Normal, PlayerName)
}

fn get_attr(message, total_points) {
  erlang.get_line(prompt(message, total_points) <> player_answer_marker())
  |> result.map(fn(health_value) { string.trim(health_value) })
  |> result.unwrap("")
  |> parse_to_int()
}

fn parse_to_int(value: String) -> Int {
  case int.parse(value) {
    Ok(int) -> int
    Error(_error) -> 0
  }
}

fn prompt(message, total_points) {
  let remaining_points_message =
    " (pontos: " <> int.to_string(total_points) <> ")"

  styles.format_message(message <> remaining_points_message, Italic, DarkRed)
}
