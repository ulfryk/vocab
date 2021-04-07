module State exposing (..)

import Set exposing (Set, empty)

import GameModel exposing (Card, Current(..), GameStats, Showing, cardsMock, initialGameStats)

type Scope = Splash | Editing Card | Playing

type alias Model = { cards: List Card, game: GameStats, archived: Set String, scope: Scope }

initial : Model
initial = {
   cards = cardsMock,
   game = initialGameStats,
   archived = empty,
   scope = Splash }
