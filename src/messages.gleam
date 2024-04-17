import shellout
import gleam/int
import gleam/io
import gleam/string
import styles.{Bold, Command, DarkRed, Normal, Strike, format_message}
import types/shared_types.{type Dragon, type Player, type Session}

pub const initial_message = "\n\n\"Após anos de investigação e busca obsessiva, você chega ao\r
labirinto indicado pela sua última pista. Guiado pela visão que\r
recebeu do mago Merlin, o Elixir da Vida estava à poucos\r
passos de ser finalmente seu.\n
Perdendo-se e encontrando-se entre os caminhos, uma luz ao longe\r
sinaliza a sua vitória.\n
Avançando seu caminho, na penumbra algo se move lentamente, impossível\r
de identificar à primeira vista. Ao aproximar-se, uma voz imponente\r
ecoa, magicamente acendendo dezenas de tochas ao seu redor, revelando\r
o dono da aterrorizante voz\"\n"

pub fn dragon_message(message) {
  shellout.command(
    run: "cowsay",
    with: ["-f", "dragon", message],
    in: ".",
    opt: [],
  )
}

pub fn session_stats(session: Session, player: Player, _dragon: Dragon) {
  io.println(
    "Vida: "
    <> int.to_string(player.health)
    <> "\n"
    <> "Respostas corretas: "
    <> int.to_string(session.right_answers)
    <> "\n"
    <> "Respostas incorretas: "
    <> int.to_string(session.wrong_answers)
    <> "\n",
  )
}

pub fn victory(player: Player) {
  io.println(
    "Parabéns "
    <> player.name
    <> ", sua jornada chegou ao fim, e a minha também.\r
Que ecoe para o mundo que "
    <> player.name
    <> " libertou o poderoso Alduin de sua tediosa vida mundana.",
  )
}

pub fn loss(player: Player) {
  io.println(
    player.name
    <> ", você provou-se apenas mais um tolo que desafia o poder da magia antiga.\r
Vá para teu descanso, pois tua jornada nesse plano chegou ao fim.",
  )
}

pub fn rules(player: Player) {
  let player_name = string.trim(player.name)

  io.println(
    format_message("\n As regras são as seguintes, ", Normal, DarkRed)
    <> player_name
    <> ". "
    <> format_message("Para sair deste labirinto com vida, você precisará\r 
responder meus enigmas. A cada erro seu, um corte\r
será feito em seu corpo. A cada acerto, o corte será\r
feito em mim.\n" <> format_message(
        "Suas respostas devem ser exatas. Não esqueça acentuação.\n
Não é culpa minha, " <> format_message(
            "o programador ficou com preguiça de tratar isso",
            Strike,
            Command,
          ) <> format_message(" a magia funciona assim.\n", Bold, DarkRed),
        Bold,
        DarkRed,
      ), Normal, DarkRed),
  )
}
