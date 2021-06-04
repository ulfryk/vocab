module Vocab.Layout exposing (..)

import Core.BEM exposing (block)
import Html exposing (Attribute, Html, div, footer, h1, h3, header, i, main_, text)
import Html.Attributes exposing (style)
import String exposing (fromInt)
import Vocab.Game.GameModel exposing (statsLength)
import Vocab.State exposing (Model, Scope(..))


layoutClass =
    block "layout"


progress : Model -> String
progress m =
    let
        total =
            statsLength m.game + m.game.countDown

        done =
            statsLength m.game

        amount =
            fromInt <| (done * 100) // total
    in
    amount ++ "%"


layout : Model -> List (Html a) -> Html a
layout model content =
    div [ layoutClass.bl ]
        [ header [ layoutClass.el "header" ]
            [ h1 [ layoutClass.el "heading" ] [ text "Vocab" ]
            , h3 [ layoutClass.el "info" ] [ text "Learn the words!" ]
            ]
        , main_
            [ layoutClass.elMod "main" ( "loading", model.loading ) ]
            content
        , footer [ layoutClass.el "footer" ] [ text "© Ulfryk 2021" ]
        , case model.scope of
            Playing ->
                div [ layoutClass.el "progress", style "height" <| progress model ] []

            _ ->
                i [] []
        ]
