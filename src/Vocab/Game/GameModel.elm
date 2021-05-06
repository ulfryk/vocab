module Vocab.Game.GameModel exposing (..)

import Set exposing (Set, empty, size)
import Vocab.DTO.Card exposing (Card)


type Showing
    = ASide
    | BSide


type Current
    = Question Showing Card
    | Answer Card
    | NoMoreCards


type alias GameStats =
    { perfect : Set String, good : Set String, bad : Set String, current : Current, countDown : Int }


initialGameStats : GameStats
initialGameStats =
    { perfect = empty, good = empty, bad = empty, current = NoMoreCards, countDown = 0 }


statsLength : GameStats -> Int
statsLength { perfect, good, bad } =
    size perfect + size good + size bad
