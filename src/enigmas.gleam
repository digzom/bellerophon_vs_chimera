import gleam/list
import gleam/int
import gleam/result

pub type Enigma {
  EnigmaRec(question: String, answer: String)
  EnigmaError(question: Nil, answer: Nil, error: String)
}

const enigmas = [
  EnigmaRec(
    question: "Sou o guardião das certezas. Defino muito bem tudo aquilo que declaro.\r
Seus erros serão encontrados antes mesmo de serem cometidos.\r
Qual característica de duas palavras eu sou?\n",
    answer: "Tipagem estática",
  ),
  EnigmaRec(
    question: "Meus valores são imutáveis. Amo a pureza e a transformação segura.\r
Qual paradigma de programação sou eu?\n",
    answer: "Funcional",
  ),
  EnigmaRec(
    question: "Falo a linguagem das máquinas, traduzindo suas ideias em instruções que\r
elas compreendem.\r
Quem sou eu?\n",
    answer: "Compilador",
  ),
  EnigmaRec(
    question: "Sou a porta para o mundo, sem que você precise viajar. Conecto as pessoas,\r
sem que elas precisem se aproximar.\n
O que sou eu?\r",
    answer: "Internet",
  ),
  EnigmaRec(
    question: "Gero raiva naqueles que me encontram atrapalhando seu caminho. Quem me\n
destrói muitas vezes foi quem me criou.\r
Não importa o que faça, ou quanto tempo demore. Uma hora ou outra eu vou aparecer novamente. Quem sou eu?\n",
    answer: "Internet",
  ),
]

pub fn get_enigma() {
  let index =
    list.length(enigmas) - 1
    |> int.random

  enigmas
  |> list.at(index)
  |> result.unwrap(EnigmaError(
    question: Nil,
    answer: Nil,
    error: "Aconteceu algo ruim...",
  ))
}
