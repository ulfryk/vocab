module State exposing (..)

import Json.Decode exposing (Error)
import Set exposing (Set, empty)

import Card exposing (Card)
import GameModel exposing (Current(..), GameStats, Showing, initialGameStats)

type Scope = Splash | Editing | Playing

type alias Model = { cards: List Card, game: GameStats, archived: Set String, scope: Scope, error: Maybe Error }

initial : Model
initial = {
   cards = [],
   game = initialGameStats,
   archived = empty,
   scope = Splash,
   error = Nothing }
