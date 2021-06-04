module Vocab.State exposing (..)

import Dict exposing (Dict, fromList, get)
import Json.Decode exposing (Error)
import Maybe exposing (andThen, withDefault)
import Set exposing (Set, empty)
import Vocab.DTO.Card exposing (Card)
import Vocab.Game.GameModel exposing (Current(..), GameStats, Showing, initialGameStats)
import Vocab.Manage.ManageModel exposing (ManageModel, initialManageModel)


type Scope
    = Splash
    | Editing
    | Playing


type alias Model =
    { cards : Dict String (List Card)
    , sheet : Maybe String
    , game : GameStats
    , archived : Set String
    , scope : Scope
    , manage : ManageModel
    , loading : Bool
    , error : Maybe Error
    }


initial : Model
initial =
    { cards = fromList []
    , sheet = Nothing
    , game = initialGameStats
    , archived = empty
    , scope = Splash
    , error = Nothing
    , manage = initialManageModel
    , loading = False
    }

getCards : Model -> List Card
getCards { cards, sheet } =
    withDefault [] << andThen (\s -> get s cards) <| sheet
