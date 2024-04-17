import gleam/io
import gleam/erlang
import gleam/int
import shellout
import gleam/result
import gleam/string
import enigmas.{type Enigma, EnigmaError, EnigmaRec}
import styles.{Command, DarkRed, Italic, LightGrey, Normal, PlayerName}
import gleam/dict

const initial_message = "\n\n\"Após anos de investigação e busca obcessiva, você chega ao\r
labirinto indicado pela sua última pista. Guiado pela visão que\r
recebeu do mago Merlin, o Elixir da Vida estava à poucos\r
passos de ser finalmente seu.\n
Perdendo-se e encontrando-se entre os caminhos, uma luz ao longe\r
sinaliza a sua vitória.\n
Avançando seu caminho, na penumbra algo se move lentamente, impossível\r
de identificar à primeira vista. Ao aproximar-se, uma voz imponente\r
ecoa, magiamente acendendo dezenas de tochas ao seu redor, revelando\r
o dono da aterrorizante voz\"\n"

pub opaque type Player {
  PlayerStats(name: String, health: Int, lucky: Int, attack: Int)
}

pub opaque type Session {
  SessionInfo(wrong_answers: Int, right_answers: Int)
}

pub opaque type Dragon {
  DragonStats(name: String, health: Int, lucky: Int, attack: Int)
}

type TurnInfo {
  Turn(
    question: String,
    answer: String,
    turn_number: Int,
    characters: #(Player, Dragon),
  )
}

pub fn main() {
  initial_message
  |> styles.format_message(Italic, LightGrey)
  |> io.println()

  let _ =
    erlang.get_line(prompt: styles.format_message(
      "<pressione enter para continuar>\n",
      Italic,
      Command,
    ))

  dragon_message("Quem me acorda de meu duradouro sono?")
  |> result.unwrap("")
  |> styles.format_message(Normal, styles.AsciiDragon)
  |> io.println()

  case get_name("Diga-me teu nome.") {
    Ok(player_name) -> {
      let player_stats =
        PlayerStats(
          name: string.trim(player_name),
          health: 20,
          lucky: 20,
          attack: 5,
        )

      let dragon_stats =
        DragonStats(name: "Alduin", health: 40, lucky: 10, attack: 5)

      rules(player_name)
      start_game(
        turn_number: 1,
        player: player_stats,
        dragon: dragon_stats,
        session: SessionInfo(wrong_answers: 0, right_answers: 0),
      )
    }

    Error(_error) -> {
      io.println("Hmmm... Esse não é um nome válido.")
      ""
    }
  }
}

fn dragon_message(message) {
  shellout.command(
    run: "cowsay",
    with: ["-f", "dragon", message],
    in: ".",
    opt: [],
  )
}

pub fn start_game(
  turn_number turn_number: Int,
  player player: Player,
  dragon dragon: Dragon,
  session session: Session,
) {
  io.println("Vida: " <> int.to_string(player.health) <> "\n")
  io.println(
    "Respostas corretas: " <> int.to_string(session.right_answers) <> "\n",
  )
  io.println(
    "Respostas incorretas: " <> int.to_string(session.wrong_answers) <> "\n",
  )

  case player.health > 0 && dragon.health > 0 {
    True -> {
      let enigma: Enigma = enigmas.get_enigma()

      case enigma {
        EnigmaError(question: Nil, answer: Nil, error: error) -> io.debug(error)
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
      case dragon.health {
        0 -> {
          io.println(
            "Parabéns "
            <> player.name
            <> ", sua jornada chegou ao fim, e a minha também.\r
Que ecoe para o mundo que "
            <> player.name
            <> " libertou o poderoso Alduin de sua tediosa vida mundana.",
          )

          ""
        }

        _ ->
          case player.health {
            0 -> {
              io.println(
                player.name
                <> ", você provou-se apenas mais um tolo que desafia o poder da magia antiga.\r
Vá para teu descanso, pois tua jornada nesse plano chegou ao fim.",
              )
              ""
            }

            _ -> {
              io.println("oxe")
              ""
            }
          }
      }
    }
  }
}

fn turn(turn_info: TurnInfo, session: Session) {
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

  use response <- result.try(erlang.get_line(
    prompt: styled_message <> "\n»» ",
  ))

  Ok(response)
}

fn rules(player_name) {
  let player_name = string.trim(player_name)

  io.println(
    styles.format_message("\n\nAs regras são as seguintes, ", Normal, DarkRed)
    <> styles.format_message(player_name, Normal, PlayerName)
    <> styles.format_message(
      ". Para sair deste labirinto com vida, você precisará responder meus enigmas.\r
A cada erro seu, um corte será feito em seu corpo. A cada acerto, o corte será feito\r
em mim.\n
Vamos começar...\"",
      Normal,
      DarkRed,
    ),
  )
}
