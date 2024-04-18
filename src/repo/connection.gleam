import sqlight

pub fn setup_tables() {
  use conn <- start()

  let create_tables =
    "
  create table if not exists character (
    player_id integer primary key,
    name text,
    health integer,
    lucky integer,
    attack integer,
    ctype text check('dragon', 'player')
  );

  create table if not exists session (
    session_id integer primary key,
    wrong_answers integer,
    right_answers integer,
    total_points real,
    foreign key(player_id) references player(player_id) 
  );
  "

  let _table_creation = sqlight.exec(create_tables, conn)
  sqlight.close(conn)
}

pub fn start(function) {
  sqlight.with_connection("../../game.db", function)
  // let sql =
  //   "
  // create table if not exists player (
  //   player_id integer primary key,
  //   name text,
  //   health integer,
  //   lucky integer,
  //   attack integer
  // );
  //
  // create table if not exists session (
  //   session_id integer primary key,
  //   wrong_answers integer,
  //   right_answers integer,
  //   foreign key(player_id) references player(player_id) 
  // );
  // "
  //
  // let sql =
  //   "
  // select name, age from cats
  // where age < ?
  // "
  // let assert Ok([#("Nubi", 4), #("Ginny", 6)]) =
  //   sqlight.query(sql, on: conn, with: [sqlight.int(7)], expecting: cat_decoder)
}
