defmodule ElixirExtension do
  def open_new_terminal() do
    System.cmd(
      "alacritty",
      [
        "-o",
        "window.padding={ x = 40, y = 40}",
        "-o",
        "window.decorations='Full'",
        "-o",
        "window.opacity=1",
        "-o",
        "window.startup_mode='Fullscreen'",
        ~s(-o),
        ~s(window.title='The Alduin\x36 Enigma'),
        ~s(-o),
        ~s(window.dynamic_title=false),
        "-o",
        "font.size=18",
        "-e",
        "gleam",
        "run",
        "-m",
        "bellerophon_vs_chimera"
      ]
    )
  end

  def title() do
    start_message = :styles.title_style("
      \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
                       Para começar, pressione enter.\n\n\n\n\n\n\n\n\n\n\n\n\n")

    press_message = :styles.press_message("<pressione enter para continuar>\n")
    IO.gets(start_message)
    string = [
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                   ▄▄▄█████▓ ██░ ██ ▓█████     ▄▄▄       ██▓    ▓█████▄  █    ██  ██▓ ███▄    █   ██████    ▓█████ ███▄    █  ██▓ ▄████  ███▄ ▄███▓ ▄▄▄       ),
      ~s(                   ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀    ▒████▄    ▓██▒    ▒██▀ ██▌ ██  ▓██▒▓██▒ ██ ▀█   █ ▒██    ▒    ▓█   ▀ ██ ▀█   █ ▓██▒██▒ ▀█▒▓██▒▀█▀ ██▒▒████▄     ),
      ~s(                   ▒ ▓██░ ▒░▒██▀▀██░▒███      ▒██  ▀█▄  ▒██░    ░██   █▌▓██  ▒██░▒██▒▓██  ▀█ ██▒░ ▓██▄      ▒███  ▓██  ▀█ ██▒▒██▒██░▄▄▄░▓██    ▓██░▒██  ▀█▄   ),
      ~s(                   ░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄    ░██▄▄▄▄██ ▒██░    ░▓█▄   ▌▓▓█  ░██░░██░▓██▒  ▐▌██▒  ▒   ██▒   ▒▓█  ▄▓██▒  ▐▌██▒░██░▓█  ██▓▒██    ▒██ ░██▄▄▄▄██  ),
      ~s(                     ▒██▒ ░ ░▓█▒░██▓░▒████▒    ▓█   ▓██▒░██████▒░▒████▓ ▒▒█████▓ ░██░▒██░   ▓██░▒██████▒▒   ░▒████▒██░   ▓██░░██░▒▓███▀▒▒██▒   ░██▒ ▓█   ▓██▒ ),
      ~s(                     ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░    ▒▒   ▓▒█░░ ▒░▓  ░ ▒▒▓  ▒ ░▒▓▒ ▒ ▒ ░▓  ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░   ░░ ▒░ ░ ▒░   ▒ ▒ ░▓  ░▒   ▒ ░ ▒░   ░  ░ ▒▒   ▓▒█░ ),
      ~s(                       ░     ▒ ░▒░ ░ ░ ░  ░     ▒   ▒▒ ░░ ░ ▒  ░ ░ ▒  ▒ ░░▒░ ░ ░  ▒ ░░ ░░   ░ ▒░░ ░▒  ░ ░    ░ ░  ░ ░░   ░ ▒░ ▒ ░ ░   ░ ░  ░      ░  ▒   ▒▒ ░ ),
      ~s(                     ░       ░  ░░ ░   ░        ░   ▒     ░ ░    ░ ░  ░  ░░░ ░ ░  ▒ ░   ░   ░ ░ ░  ░  ░        ░     ░   ░ ░  ▒ ░ ░   ░ ░      ░     ░   ▒    ),
      ~s(                             ░  ░  ░   ░  ░         ░  ░    ░  ░   ░       ░      ░           ░       ░        ░  ░        ░  ░       ░        ░         ░  ░ ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
      ~s(                                                                                                                                                              ),
    ]
    Enum.each(string, fn line -> 
      :timer.sleep(50)
      line = :styles.title_style(line)
      IO.puts(line)
    end)
    IO.gets(press_message)
  end
end

