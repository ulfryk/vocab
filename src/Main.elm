port module Main exposing (..)

import Browser
import Html exposing (Html)
import Json.Decode as Decode
import Json.Encode as Encode
import Set exposing (insert, remove)

import State exposing (Model, Scope(..), initial)
import Layout exposing (layout)

import Vocab.DTO.Card exposing (cardId)
import Vocab.DTO.DataSnapshot exposing (DataSnapshot, dataSnapshotDecoder, encodeDataSnapshot)
import Base.SplashMsg exposing (SplashMsg(..))
import Base.SplashHtml exposing (splashView)
import GameModel exposing (GameStats)
import PlayMsg exposing (PlayMsg(..), updateOnPlay)
import GameViewHtml exposing (gameView)
import Manage.ManageViewHtml exposing (manageView)
import Manage.ManageMsg exposing (ManageMsg(..))

type Msg = Play PlayMsg | Manage ManageMsg | Basic SplashMsg

port syncData : Encode.Value -> Cmd msg

initialModel : Decode.Value -> (Model, Cmd Msg)
initialModel flags =
    let data = Decode.decodeValue dataSnapshotDecoder flags in
    case data of
        Ok value -> ({ initial | cards = value.cards, archived = value.archived }, Cmd.none)
        Err err -> ({ initial | error = Just err }, Cmd.none)

subscriptions : Model ->  Sub Msg
subscriptions _ = Sub.none

liftPlayUpdate : Model -> (a -> Msg) -> (GameStats, Cmd a) -> (Model, Cmd Msg)
liftPlayUpdate model mapper (game, command) = ({ model | game = game}, Cmd.map mapper command)

main =
  Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ game, archived, cards } as model) =
  case msg of
    Play m -> case m of
        GameEnd arch -> (
          { model | archived = arch, scope = Splash },
          syncData <| encodeDataSnapshot { cards = cards, archived = arch })
        _ -> liftPlayUpdate model Play <| updateOnPlay m archived cards game
    Manage m -> case m of
        Done -> ({ model | scope = Splash } , Cmd.none)
        ToggleArchived toggle card -> case toggle of
            True -> ({ model | archived = insert (cardId card) archived }, Cmd.none)
            False -> ({ model | archived = remove (cardId card) archived }, Cmd.none)
    Basic m -> case m of
        StartGame -> liftPlayUpdate { model | scope = Playing } Play <| updateOnPlay Start archived cards game
        StartEditing -> ({ model | scope = Editing }, Cmd.none)


view : Model -> Html Msg
view model =
    layout model [
      case model.scope of
        Splash -> Html.map Basic <| splashView ()
        Playing -> Html.map Play <| gameView model.game
        Editing -> Html.map Manage <| manageView model.archived model.cards
  ]
