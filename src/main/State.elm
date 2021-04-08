module State exposing (..)

import Set exposing (Set, empty)

import Card exposing (Card)
import GameModel exposing (Current(..), GameStats, Showing, initialGameStats)

type Scope = Splash | Editing Card | Playing

type alias Model = { cards: List Card, game: GameStats, archived: Set String, scope: Scope }

initial : Model
initial = {
   cards = [],
   game = initialGameStats,
   archived = empty,
   scope = Splash }
