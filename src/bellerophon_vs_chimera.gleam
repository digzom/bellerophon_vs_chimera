import gleam/io
import gleam/erlang
import shellout
import gleam/result
import gleam/string
import gleam/int
import enigmas.{type Enigma, EnigmaError, EnigmaRec}
import styles.{Command, Italic, Normal, PlayerName}
import gleam/dict
import types/shared_types.{
  type Dragon, type Player, type Session, DragonStats, PlayerStats, SessionInfo,
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

pub fn main() {
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

  case get_name("Diga-me teu nome.") {
    Ok(player_name) -> {
      let styled_player_name =
        player_name
        |> string.trim()
        |> styles.format_message(Normal, PlayerName)

      let player_stats =
        PlayerStats(name: styled_player_name, health: 20, lucky: 20, attack: 5)

      let dragon_stats =
        DragonStats(name: "Alduin", health: 40, lucky: 10, attack: 5)

      messages.rules(player_stats)
      start_game(
        turn_number: 1,
        player: player_stats,
        dragon: dragon_stats,
        session: SessionInfo(wrong_answers: 0, right_answers: 0),
      )
    }

    Error(_error) -> io.println("Hmmm... Esse não é um nome válido.")
  }
}

pub fn start_game(
  turn_number turn_number: Int,
  player player: Player,
  dragon dragon: Dragon,
  session session: Session,
) -> Nil {
  messages.session_stats(session, player, dragon)

  let _response = erlang.get_line(prompt: "-------------------------------------")

  case player.health > 0 && dragon.health > 0 {
    True -> {
      let enigma: Enigma = enigmas.get_enigma()

      case enigma {
        EnigmaError(question: Nil, answer: Nil, error: error) ->
          io.println(error)
        EnigmaRec(question, answer) -> {
          let turn_info =
            Turn(
              question: question,
              answer: answer,
              turn_number: turn_number,
              characters: #(player, dragon),
            )

          turn(turn_info, session)
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
    0 -> messages.victory(player)

    _ -> {
      check_player_health(player)
    }
  }
}

fn check_player_health(player: Player) -> Nil {
  case player.health {
    0 -> messages.loss(player)

    _ -> io.println("oxe")
  }
}

fn turn(turn_info: TurnInfo, session: Session) -> Nil {
  // transformar turn da charada em string "primeira, segunda..." e criar um
  // map para acessar o valor com o numero
  io.println(
    "------------- CHARADA "
    <> int.to_string(turn_info.turn_number)
    <> " -------------\n",
  )
  let response = erlang.get_line(prompt: turn_info.question)

  let user_answer =
    result.unwrap(response, "porraaaa")
    |> string.trim()

  let is_right_answer = turn_info.answer == user_answer

  let #(player, dragon) = turn_info.characters
  let turn_number = turn_info.turn_number + 1

  case is_right_answer {
    True -> {
      let damage = dragon.health - player.attack
      let updated_dragon = DragonStats(..dragon, health: damage)

      io.println("Parabéns... Você viverá um pouco mais.\n")

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
      let damage = player.health - dragon.attack
      let updated_player = PlayerStats(..player, health: damage)

      io.println("Você vai sofrer...")

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
fn get_name(message) {
  let style =
    shellout.display(["italic"])
    |> dict.merge(from: shellout.color(["dark_red"]))

  let styled_message =
    shellout.style(message, with: style, custom: styles.lookups)

  let player_answer_marker =
    styles.format_message("\n»» ", Normal, PlayerName)

  use response <- result.try(erlang.get_line(
    prompt: styled_message <> player_answer_marker,
  ))

  Ok(response)
}
