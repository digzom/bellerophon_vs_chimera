import gleam/io
import gleam/erlang
import shellout
import gleam/result
import gleam/string

pub fn main() {
  let this_one =
    shellout.arguments()
    |> shellout.command(
      run: "cowsay -f dragon 'hello motherfucker'",
      in: ".",
      opt: [],
    )

  io.debug(this_one)

  let player_name = case greetings() {
    Ok(player_name) -> player_name
    Error(_error) -> {
      panic
    }
  }

  listen_for_command(player_name)
}

pub fn listen_for_command(player_name) -> Nil {
  case
    greetings_text(player_name)
    |> erlang.get_line()
  {
    Ok("Caixão\n") -> {
      io.println("Parabéns guerreiro. Você viverá por mais algumas horas.")

      listen_for_command(player_name)
    }

    _resultado -> {
      io.debug("Errou! Morreu!")

      listen_for_command(player_name)
    }
  }
}

fn greetings() {
  use response <- result.try(erlang.get_line(
    prompt: "Diga-me teu nome, guerreiro.\n»» ",
  ))

  Ok(response)
}

fn greetings_text(player_name) -> String {
  let player_name = string.trim(player_name)

  player_name
  <> ", para passar daqui, você precisará responder meus enigmas.\n
Responda este para viver:\n\r
Quem me usa, não sabe que me usa. Quem me compra, não me usa. Quem me vender, não me quer.\n\r"
}
