module DoneHtml exposing (..)

import Html exposing (Html, button, p, text)

import Html.Events exposing (onClick)
import Play exposing (PlayMsg(..))
import State exposing (Model)

doneView : Model -> Html PlayMsg
doneView m =
    p [] [ text "done ", button [ onClick  End ] [ text "finish"] ]

