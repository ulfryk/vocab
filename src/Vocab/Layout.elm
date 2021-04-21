module Vocab.Layout exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import Html exposing (Attribute, Html, div, footer, h1, h3, header, i, main_, text)
import Html.Attributes exposing (style)
import List exposing (length)
import String exposing (fromInt)
import Vocab.Game.PlayMsg exposing (getAvailableCards)
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
            length m.cards

        done =
            length << getAvailableCards m.archived m.cards <| m.game

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
                div [ elemClass "progress", style "bottom" <| progress model ] []

            _ ->
                i [] []
        ]
