module Vocab.Game.GameModel exposing (..)

import Set exposing (Set, empty)
import Vocab.DTO.Card exposing (Card)


type Showing
    = ASide
    | BSide


type Current
    = Question Showing Card
    | Answer Card
    | NoMoreCards


type alias GameStats =
    { perfect : Set String, good : Set String, bad : Set String, current : Current }


initialGameStats : GameStats
initialGameStats =
    { perfect = empty, good = empty, bad = empty, current = NoMoreCards }
