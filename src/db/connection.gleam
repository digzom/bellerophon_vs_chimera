import gleam/dynamic
import sqlight

pub fn start_db() {
  use conn <- sqlight.with_connection("../../game.db")
  let cat_decoder = dynamic.tuple2(dynamic.string, dynamic.int)

  let sql =
    "
  create table if not exists player (
    player_id integer primary key,
    name text,
    health integer,
    lucky integer,
    attack integer
  );

  create table if not exists session (
    session_id integer primary key,
    wrong_answers integer,
    right_answers integer,
    foreign key(player_id) references player(player_id) 
  );
  "
  let assert Ok(Nil) = sqlight.exec(sql, conn)
  //
  // let sql =
  //   "
  // select name, age from cats
  // where age < ?
  // "
  // let assert Ok([#("Nubi", 4), #("Ginny", 6)]) =
  //   sqlight.query(sql, on: conn, with: [sqlight.int(7)], expecting: cat_decoder)
}
