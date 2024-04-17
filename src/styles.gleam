import shellout.{type Lookups}
import gleam/dict

pub type MessageColors {
  DarkRed
  Mint
  Buttercup
  LightGrey
  White
  PlayerName
  Command
  AsciiDragon
}

pub type MessageDisplays {
  Italic
  Bold
  Normal
  Blink
}

pub const lookups: Lookups = [
  #(
    ["color", "background"],
    [
      #("buttercup", ["252", "226", "174"]),
      #("mint", ["182", "255", "234"]),
      #("pink", ["255", "175", "243"]),
      #("dark_red", ["189", "10", "9"]),
      #("light_grey", ["150", "150", "150"]),
      #("command", ["60", "60", "60"]),
      #("white", ["200", "200", "199"]),
      #("player_name", ["0", "200", "100"]),
      #("ascii_dragon", ["200", "50", "50"]),
    ],
  ),
]

pub fn format_message(
  message,
  font_style: MessageDisplays,
  color: MessageColors,
) -> String {
  let color = get_color(color)
  let display = get_display(font_style)

  let style =
    shellout.display([display])
    |> dict.merge(from: shellout.color([color]))

  shellout.style(message, with: style, custom: lookups)
}

fn get_color(color: MessageColors) -> String {
  case color {
    DarkRed -> "dark_red"
    Mint -> "mint"
    Buttercup -> "buttercup"
    LightGrey -> "light_grey"
    White -> "white"
    PlayerName -> "player_name"
    Command -> "command"
    AsciiDragon -> "ascii_dragon"
  }
}

fn get_display(display: MessageDisplays) -> String {
  case display {
    Italic -> "italic"
    Bold -> "bold"
    Normal -> "normal"
    Blink -> "blink"
  }
}
