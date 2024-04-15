import gleam/io
import gleam/erlang
import shellout
import gleam/result
import gleam/string
import enigmas.{type Enigma, EnigmaError, EnigmaRec}

type Player {
  PlayerStats(Stats)
}

type Session {
  SessionInfo(wrong_answers: Int, right_answers: Int, player_info: Player)
}

type Dragon {
  DragonStats(Stats)
}

type Stats {
  StatsInfo(name: String, health: Int, lucky: Int, attack: Int)
}

pub fn main() {
  dragon_message("Quem me acorda de meu duradouro sono?")
  |> result.unwrap("")
  |> io.println()

  case greetings() {
    Ok(player_name) -> rules(player_name)

    Error(_error) -> {
      io.println("Hmmm... Esse não é um nome válido.")
    }
  }

  start_game()
}

fn dragon_message(message) {
  shellout.command(
    run: "cowsay",
    with: ["-f", "dragon", message],
    in: ".",
    opt: [],
  )
}

pub fn start_game() {
  let enigma: Enigma = enigmas.get_enigma()

  case enigma {
    EnigmaError(question: Nil, answer: Nil, error: error) -> io.debug(error)
    EnigmaRec(question, answer) -> turn(question, answer)
  }
}

fn turn(question: String, answer: String) {
  let response = erlang.get_line(prompt: question)

  let user_answer =
    result.unwrap(response, "porraaaa")
    |> string.trim()

  let is_right_answer = answer == user_answer

  case is_right_answer {
    True -> io.println("Parabéns... Você viverá um pouco mais.")
    False -> io.println("Você vai sofrer...")
  }

  start_game()
}

// dar um jeito de nao chamar charadas repetidas na mesma sessao
fn greetings() {
  use response <- result.try(erlang.get_line(prompt: "Diga-me teu nome.\n»» "))

  Ok(response)
}

fn rules(player_name) {
  let player_name = string.trim(player_name)

  io.println(
    "\n\rOlá, "
    <> player_name
    <> ". Para sair deste labirinto com vida, você precisará responder meus enigmas.\n
A cada erro seu, um corte será feito em seu corpo. A cada acerto, o corte será feito em mim.\n
Vamos começar...\n",
  )
}
