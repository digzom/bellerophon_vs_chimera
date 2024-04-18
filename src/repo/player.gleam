import repo/connection
import gleam/dynamic
import sqlight
import types/shared_types.{type Player}

pub fn create_table() {
  use conn <- connection.start()

  let sql =
    "
  create table if not exists player (
    player_id integer primary key autoincrement,
    name text,
    health integer,
    lucky integer,
    attack integer
  );
  "

  sqlight.exec(sql, conn)
}

pub fn save_player(player: Player) {
  use conn <- connection.start()
  let player_decoder =
    dynamic.tuple4(dynamic.string, dynamic.float, dynamic.int, dynamic.int)

  let sql =
    "insert into player(name, health, lucky, attack) values (?, ?, ?, ?);"

  let params = [
    sqlight.text(player.name),
    sqlight.float(player.health),
    sqlight.int(player.lucky),
    sqlight.int(player.attack),
  ]

  sqlight.query(sql, on: conn, with: params, expecting: player_decoder)
}
