module Vocab.Layout exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import Html exposing (Attribute, Html, div, footer, h1, h3, header, i, main_, text)
import Html.Attributes exposing (style)
import String exposing (fromInt)
import Vocab.Game.GameModel exposing (statsLength)
import Vocab.State exposing (Model, Scope(..))


bemTools =
    bem "layout"


blockClass =
    getRootClass bemTools


elemClass =
    getElemClassFactory bemTools


elemModClass =
    getElemModsClassFactory bemTools


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
    div [ blockClass ]
        [ header [ elemClass "header" ]
            [ h1 [ elemClass "heading" ] [ text "Vocab" ]
            , h3 [ elemClass "info" ] [ text "Learn the words!" ]
            ]
        , main_
            [ elemModClass "main"
                (if model.loading then
                    [ "loading" ]

                 else
                    []
                )
            ]
            content
        , footer [ elemClass "footer" ] [ text "© Ulfryk 2021" ]
        , case model.scope of
            Playing ->
                div [ elemClass "progress", style "height" <| progress model ] []

            _ ->
                i [] []
        ]
