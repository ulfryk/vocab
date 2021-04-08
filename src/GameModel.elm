module GameModel exposing (..)

import Set exposing (Set, empty)
type alias Card = { aSide: String, bSide: String }

type Showing = ASide | BSide

type Current = Question Showing Card | Answer Card | NoMoreCards

type alias GameStats = { perfect: Set String, good: Set String, bad: Set String, current: Current }



cardId : Card -> String
cardId { aSide, bSide } = aSide ++ ":" ++ bSide

initialGameStats : GameStats
initialGameStats = { perfect = empty, good = empty, bad = empty, current = NoMoreCards }
