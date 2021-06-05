module Vocab.Model exposing (..)

import Dict exposing (Dict, fromList, get, keys)
import Http
import Json.Decode as D exposing (Decoder)
import Maybe exposing (andThen, withDefault)
import Set exposing (Set, empty)
import Vocab.Api.DTO.Card exposing (Card)
import Vocab.Game.GameModel as GameModel
import Vocab.Manage.ManageData exposing (ManageData)
import Vocab.Manage.ManageModel as ManageModel
import Vocab.Splash.SplashData exposing (SplashData)


type Scope
    = Splash
    | Editing
    | Playing


type alias Model =
    { cards : Dict String (List Card)
    , sheet : Maybe String
    , archived : Set String
    , scope : Scope
    , loading : Bool
    , error : Maybe D.Error
    , httpError : Maybe Http.Error
    , game : GameModel.GameModel
    , manage : ManageModel.ManageModel
    }


initial : Model
initial =
    { cards = fromList []
    , sheet = Nothing
    , archived = empty
    , scope = Splash
    , error = Nothing
    , loading = False
    , httpError = Nothing
    , game = GameModel.initialGameStats
    , manage = ManageModel.initialManageModel
    }


getCards : Model -> List Card
getCards { cards, sheet } =
    withDefault [] << andThen (\s -> get s cards) <| sheet


toSplashData : Model -> SplashData
toSplashData ({ cards, sheet } as m) =
    { sheets = keys cards
    , cards = getCards m
    , selected = sheet
    }


toManageData : Model -> ManageData
toManageData ({ manage, archived } as m) =
    { archived = archived
    , cards = getCards m
    , model = manage
    }



--decodeModel : Decoder Model
--decodeModel =
--    D.succeed Model
--        |> required "archived" (D.map S.fromList <| D.list D.string)
--        |> required "manage" decodeManageModel
--        |> required "sheet" (D.maybe D.string)
--
--
--encodeModel : Model -> E.Value
--encodeModel { archived, manage } =
--    E.object
--        [ ( "archived", E.array E.string <| A.fromList << S.toList <| archived )
--        , ( "creds", encodeManageModel manage )
--        ]
