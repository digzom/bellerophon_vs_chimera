import gleam/float
import gleam/int
import gleam/io
import gleam/string
import shellout
import styles.{
  Bold, DarkRed, Italic, LightGrey, Normal, PlayerName, format_message,
}
import types/shared_types.{type Dragon, type Player, type Session}

const initial_message = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
\"Após anos de investigação e busca obsessiva, você chega ao\r
labirinto indicado pela sua última pista. Guiado pela visão que\r
recebeu do mago Merlin, o Elixir da Vida estava à poucos\r
passos de ser finalmente seu.\n
Perdendo-se e encontrando-se entre os caminhos, uma luz ao longe\r
sinaliza a sua vitória.\n
Avançando seu caminho, na penumbra algo se move lentamente, impossível\r
de identificar à primeira vista. Ao aproximar-se, uma voz imponente\r
ecoa, magicamente acendendo dezenas de tochas ao seu redor, revelando\r
o dono da aterrorizante voz\"\n"

pub fn initial() -> Nil {
  initial_message
  |> styles.format_message(Italic, LightGrey)
  |> io.println()
}

pub fn dragon_message(message) {
  shellout.command(
    run: "cowsay",
    with: ["-f", "dragon", message],
    in: ".",
    opt: [],
  )
}

pub fn session_stats(session: Session, player: Player, dragon: Dragon) {
  io.println(
    "------------- "
    <> player.name
    <> " -------------\n"
    <> format_message("Vida: ", Bold, LightGrey)
    <> format_message(float.to_string(player.health), Normal, PlayerName)
    <> "\n"
    <> format_message("Respostas corretas: ", Bold, LightGrey)
    <> format_message(int.to_string(session.right_answers), Normal, PlayerName)
    <> "\n"
    <> format_message("Respostas incorretas: ", Bold, LightGrey)
    <> format_message(int.to_string(session.wrong_answers), Normal, PlayerName)
    <> "\n"
    <> format_message("Vida de Alduin: ", Bold, LightGrey)
    <> format_message(float.to_string(dragon.health), Normal, DarkRed),
  )
}

pub fn victory(player: Player) {
  "Parabéns "
  <> player.name
  <> ", sua jornada chegou ao fim, e a minha também.\r
Que ecoe para o mundo que "
  <> player.name
  <> " libertou o poderoso Alduin de sua tediosa vida mundana. O Elixir da Vida te espera."
}

pub fn loss(player: Player) {
  player.name
  <> ", você provou-se apenas mais um tolo que desafia o poder da magia antiga.\r
Vá para teu descanso, pois tua jornada nesse plano chegou ao fim."
}

pub fn rules(player: Player) {
  let player_name = string.trim(player.name)
  let five_rules =
    format_message(
      ", nesse momento estamos sob 4 regras imutáveis:\n\n",
      Italic,
      DarkRed,
    )

  let rule1 =
    format_message(
      "  1. Para sair deste labirinto com vida, você precisará 6 enigmas ou causar minha morte.\n",
      Bold,
      DarkRed,
    )
  let rule2 =
    format_message(
      "  2. A cada erro seu, um corte será feito em seu corpo.\n",
      Bold,
      DarkRed,
    )
  let rule3 =
    format_message(
      "  3. A cada acerto, o corte será feito em mim.\n",
      Bold,
      DarkRed,
    )
  let rule4 =
    format_message(
      "  4. Suas respostas devem ser exatamente o que estou esperando. Não esqueça acentuação.\n",
      Bold,
      DarkRed,
    )

  string.concat(["\n", player_name, five_rules, rule1, rule2, rule3, rule4])
  |> io.println()
}
