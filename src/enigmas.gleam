import gleam/list
import gleam/io
import gleam/int
import gleam/result
import types/shared_types.{type Session, EnigmaError, EnigmaRec, SessionInfo}

pub const enigmas = [
  EnigmaRec(
    question: "Sou o guardião das certezas. Defino muito bem tudo aquilo que declaro. Seus erros serão encontrados antes mesmo de serem cometidos.
Qual característica de duas palavras eu sou?\r",
    answer: "Tipagem estática",
  ),
  EnigmaRec(
    question: "Meus valores são imutáveis. Amo a pureza e a transformação segura. Qual paradigma de programação sou eu?",
    answer: "Funcional",
  ),
  EnigmaRec(
    question: "Falo a linguagem das máquinas, traduzindo suas ideias em instruções que elas compreendem.
Quem sou eu?",
    answer: "Compilador",
  ),
  EnigmaRec(
    question: "Sou a porta para o mundo, sem que você precise viajar. Conecto as pessoas,
sem que elas precisem se aproximar.
O que sou eu?",
    answer: "Internet",
  ),
  EnigmaRec(
    question: "Gero raiva naqueles que me encontram atrapalhando seu caminho. Quem me destrói muitas vezes foi quem me criou. Não importa o que faça, ou quanto tempo demore.
Uma hora ou outra eu vou aparecer novamente.
Quem sou eu?",
    answer: "Bug",
  ),
  EnigmaRec(
    question: "Te ajudo a cuidar das suas várias versões e os conflitos entre elas. Muitos me usam todos os dias, mas poucos sabem do que eu realmente sou capaz.
Quem sou eu?",
    answer: "Git",
  ),
  EnigmaRec(
    question: "Sou uma linguagem odiada por muitos, amada por muitos outros, e amplamente conhecida até por quem nunca me usou. Por aqueles de constroem a Web, eu sou praticamente inevitável.
Qual linguagem eu sou?",
    answer: "Javascript",
  ),
  EnigmaRec(
    question: "Se a internet é o oceano, eu sou o navio que explora o mares das infinitas informações. Quando minha replicação foi permitida, uma guerra iniciou-se.
Quem sou eu?",
    answer: "Browser",
  ),
  EnigmaRec(
    question: "Sou a unidade fundamental. Toda informação começa comigo. O que eu sou?",
    answer: "Um bit",
  ),
  EnigmaRec(
    question: "Meu criador tem a fama de não ser muito gentil com quem quer ajudar à me aprimorar. Qual SO eu sou?",
    answer: "Linux",
  ),
]

pub fn get_enigma(session: Session) {
  let index =
    list.length(session.current_enigma_list) - 1
    |> int.random
    |> int.clamp(min: 0, max: 100)

  let current_enigma =
    session.current_enigma_list
    |> list.at(index)
    |> result.unwrap(EnigmaError("Aconteceu algo ruim..."))

  case current_enigma {
    EnigmaError(_error_message) -> #(current_enigma, session)
    EnigmaRec(question: _, answer: current_enigma_answer) -> {
      let updated_enigma_list =
        list.filter(session.current_enigma_list, fn(enigma_rec) {
          case enigma_rec {
            EnigmaRec(_question, answer) -> answer != current_enigma_answer
            EnigmaError(_error) -> False
          }
        })

      let updated_session =
        SessionInfo(..session, current_enigma_list: updated_enigma_list)

      #(current_enigma, updated_session)
    }
  }
}
