module Vocab.Model exposing (..)

import Array as A
import Dict exposing (Dict, fromList, get, keys)
import Json.Decode as D
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as E
import Maybe exposing (andThen, map, withDefault)
import Set as S exposing (Set, empty)
import Vocab.Api.DTO.Card exposing (Card, cardDecoder, encodeCard)
import Vocab.Game.GameModel as GameModel exposing (decodeGameModel, encodeGameModel)
import Vocab.Manage.ManageData exposing (ManageData)
import Vocab.Manage.ManageModel as ManageModel exposing (decodeManageModel, encodeManageModel)
import Vocab.Splash.SplashViewModel exposing (SplashViewModel)


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
    , error : Maybe String
    , game : GameModel.GameModel
    , manage : ManageModel.ManageModel
    }


initial : Model
initial =
    { cards = fromList []
    , sheet = Nothing
    , archived = empty
    , scope = Splash
    , loading = False
    , error = Nothing
    , game = GameModel.initialGameStats
    , manage = ManageModel.initialManageModel
    }


getCards : Model -> List Card
getCards { cards, sheet } =
    withDefault [] << andThen (\s -> get s cards) <| sheet


toSplashViewModel : Model -> SplashViewModel
toSplashViewModel ({ cards, sheet } as m) =
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


scopeDecoder : String -> D.Decoder Scope
scopeDecoder tag =
    case tag of
        "Splash" ->
            D.succeed Splash

        "Editing" ->
            D.succeed Editing

        "Playing" ->
            D.succeed Playing

        _ ->
            D.fail (tag ++ " is not a recognized tag for Scope")


scopeEncoder : Scope -> E.Value
scopeEncoder scope =
    case scope of
        Splash ->
            E.string "Splash"

        Editing ->
            E.string "Editing"

        Playing ->
            E.string "Playing"


falseDecoder : D.Decoder Bool
falseDecoder =
    D.succeed False


decodeModel : D.Decoder Model
decodeModel =
    D.succeed Model
        |> optional "cards" (D.dict (D.list cardDecoder)) initial.cards
        |> optional "sheet" (D.maybe D.string) initial.sheet
        |> optional "archived" (D.map S.fromList <| D.list D.string) initial.archived
        |> optional "scope" (D.andThen scopeDecoder D.string) initial.scope
        |> optional "loading" falseDecoder initial.loading
        |> optional "error" (D.maybe D.string) initial.error
        |> optional "game" decodeGameModel initial.game
        |> optional "manage" decodeManageModel initial.manage


encodeModel : Model -> E.Value
encodeModel model =
    E.object
        [ ( "cards", model.cards |> E.dict identity (E.list encodeCard) )
        , ( "sheet", model.sheet |> withDefault E.null << map E.string )
        , ( "archived", model.archived |> E.array E.string << A.fromList << S.toList )
        , ( "scope", model.scope |> scopeEncoder )
        , ( "loading", model.loading |> E.bool )
        , ( "error", model.error |> withDefault E.null << map E.string )
        , ( "game", model.game |> encodeGameModel )
        , ( "manage", model.manage |> encodeManageModel )
        ]
