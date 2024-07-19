import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub opaque type DateTime {
  Day
  Hour
  Minute
  Month
  Second
  Year
}

type Result(a, b) {
  Ok(a)
}

@external(erlang, "Elixir.DateTime", "utc_now")
fn elixir_utc_now() -> Dict(DateTime, Int)

@external(erlang, "Elixir.Time", "new")
fn elixir_new_time(
  hour: Int,
  minute: Int,
  second: Int,
) -> Result(Dict(DateTime, a), Nil)

pub fn new_time(hour, minute, second) {
  let Ok(time_params) = elixir_new_time(hour, minute, second)

  let assert [hour, minute, second] =
    time_params
    |> get_these([Hour, Minute, Second])
    |> list.map(fn(part) {
      int.to_string(part)
      |> string.pad_left(2, "0")
    })

  string.join([hour, minute, second], ":")
}

pub fn utc_now() {
  let assert [day, month, year, hour, minute, second] =
    elixir_utc_now()
    |> get_these([Day, Month, Year, Hour, Minute, Second])
    |> list.map(fn(part) {
      int.to_string(part)
      |> string.pad_left(2, "0")
    })

  string.join(
    [
      string.join([day, month, year], "/"),
      string.join([hour, minute, second], ":"),
    ],
    " ",
  )
}

fn get_these(dict: Dict(a, b), keys: List(a)) -> List(b) {
  list.map(keys, fn(key) { dict.get(dict, key) })
  |> result.values()
}
