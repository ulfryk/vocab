module Main exposing (..)

import Browser
import GameModel exposing (GameStats)
import Html exposing (Html, text)

import State exposing (Model, Scope(..), initial)
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

liftPlayUpdate : Model -> (a -> Msg) -> (GameStats, Cmd a) -> (Model, Cmd Msg)
liftPlayUpdate model mapper (game, command) = ({ model | game = game}, Cmd.map mapper command)

main =
  Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ game, archived, cards } as model) =
  case msg of
    Play m -> case m of
        GameEnd arch -> ({ model | archived = arch, scope = Splash }, Cmd.none)
        _ -> liftPlayUpdate model Play <| updateOnPlay m archived cards game
    Manage _ -> (model, Cmd.none)

view : Model -> Html Msg
view model =
    layout model [
      case model.scope of
        Splash -> Html.map Play <| splashView model
        Playing -> Html.map Play <| handleCard model.game
        Editing _ -> text "…"
  ]
