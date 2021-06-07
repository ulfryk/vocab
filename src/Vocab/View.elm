module Vocab.View exposing (..)


import Html exposing (Html)
import Vocab.Game.GameView exposing (gameView)
import Vocab.Layout exposing (layout)
import Vocab.Manage.ManageView exposing (manageView)
import Vocab.Model exposing (Model, Scope(..), toManageData, toSplashViewModel)
import Vocab.Msg exposing (Msg(..))
import Vocab.Splash.SplashView exposing (splashView)

view : Model -> Html Msg
view model =
    layout model
        (case model.scope of
            Splash ->
                Html.map Basic << splashView << toSplashViewModel <| model

            Playing ->
                Html.map Play << gameView <| model.game

            Editing ->
                Html.map Manage << manageView << toManageData <| model
        )
