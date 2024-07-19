import datetime
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn utc_now_test() {
  datetime.new_time(23, 40, 1)
  |> should.equal("23:40:01")
}
