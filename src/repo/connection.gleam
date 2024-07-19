import sqlight

pub fn setup_tables() {
  use conn <- start()

  let create_tables =
    "create table if not exists character (
    player_id integer primary key autoincrement,
    name text,
    health real,
    lucky integer,
    attack integer,
    inserted_at text,
    updated_at text,
    ctype text check(ctype in ('dragon', 'player'))
  );    

  create table if not exists session (
    session_id integer primary key,
    wrong_answers integer,
    right_answers integer,
    total_points real,
    inserted_at text
    updated_at text,
    player_id,
    foreign key(player_id) references player(player_id)
  );
  "

  let _table_creation = sqlight.exec(create_tables, conn)

  sqlight.close(conn)
}

pub fn start(function) {
  sqlight.with_connection("../../game.db", function)
}
