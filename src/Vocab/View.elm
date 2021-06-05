module Vocab.View exposing (..)


import Html exposing (Html)
import Vocab.Game.GameViewHtml exposing (gameView)
import Vocab.Layout exposing (layout)
import Vocab.Manage.ManageViewHtml exposing (manageView)
import Vocab.Model exposing (Model, Scope(..), toManageData, toSplashData)
import Vocab.Msg exposing (Msg(..))
import Vocab.Splash.SplashHtml exposing (splashView)

view : Model -> Html Msg
view model =
    layout model
        (case model.scope of
            Splash ->
                Html.map Basic << splashView << toSplashData <| model

            Playing ->
                Html.map Play << gameView <| model.game

            Editing ->
                Html.map Manage << manageView << toManageData <| model
        )
