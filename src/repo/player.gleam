import repo/connection
import gleam/dynamic
import sqlight
import types/shared_types.{type Player}
import datetime

pub fn get_players() {
  use conn <- connection.start()
  let player_decoder = dynamic.tuple2(dynamic.int, dynamic.float)

  let sql = "select player_id, health from character;"

  sqlight.query(sql, on: conn, with: [], expecting: player_decoder)
}

pub fn save_player(player: Player) {
  use conn <- connection.start()

  let sql =
    "insert into character (
      name,
      health,
      lucky,
      attack,
      ctype,
      inserted_at,
      updated_at
    ) values (?, ?, ?, ?, 'player', ?, ?);"

  let params = [
    sqlight.text(player.name),
    sqlight.float(player.health),
    sqlight.int(player.lucky),
    sqlight.int(player.attack),
    sqlight.text(datetime.utc_now()),
    sqlight.text(datetime.utc_now()),
  ]

  sqlight.query(sql, on: conn, with: params, expecting: Ok)
}
