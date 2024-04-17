pub type Player {
  PlayerStats(name: String, health: Int, lucky: Int, attack: Int)
}

pub type Session {
  SessionInfo(wrong_answers: Int, right_answers: Int)
}

pub type Dragon {
  DragonStats(name: String, health: Int, lucky: Int, attack: Int)
}
