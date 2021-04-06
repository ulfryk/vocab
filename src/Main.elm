module Main exposing (..)

import Browser
import Html exposing (Html, text)

import State exposing (Card, Model, Scope(..), Showing(..), initial)
import Manage exposing (ManageMsg)
import Play exposing (PlayMsg(..), updateOnPlay)

import Layout exposing (layout)
import HandleCardHtml exposing (handleCard)
import DoneHtml exposing (doneView)
import SplashHtml exposing (splashView)

type Msg = Play PlayMsg | Manage ManageMsg

initialModel : () -> (Model, Cmd Msg)
initialModel _ = (initial, Cmd.none)

subscriptions : Model ->  Sub Msg
subscriptions _ = Sub.none

mapSubUpdateCmd : (a -> Msg) -> (Model, Cmd a) -> (Model, Cmd Msg)
mapSubUpdateCmd mapper (m, c) = (m, Cmd.map mapper c)

main =
  Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ game, archived } as model) =
  case msg of
    Play m -> mapSubUpdateCmd Play <| updateOnPlay m model
    Manage m -> (model, Cmd.none)

view : Model -> Html Msg
view model =
    layout model [
      case model.scope of
        Splash -> Html.map Play <| splashView model
        Editing _ -> text "…"
        Playing show card -> Html.map Play <| handleCard show card
        Done -> Html.map Play <| doneView model
  ]
