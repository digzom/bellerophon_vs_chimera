pub type Player {
  PlayerStats(name: String, health: Float, lucky: Int, attack: Int)
}

pub type Session {
  SessionInfo(
    wrong_answers: Int,
    right_answers: Int,
    current_enigma_list: List(Enigma),
  )
}

pub type Dragon {
  DragonStats(name: String, health: Float, lucky: Int, attack: Int)
}

pub type Enigma {
  EnigmaRec(question: String, answer: String)
  EnigmaError(String)
}
