module DoneHtml exposing (..)

import BEM exposing (bem, getElemClassFactory, getRootClass)
import Html exposing (Html, button, p, section, text)

import Html.Events exposing (onClick)
import Play exposing (PlayMsg(..))
import State exposing (Model)

bemTools = bem "all-done"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

doneView : Model -> Html PlayMsg
doneView m =
    section [ blockClass ] [
      p [ elemClass "info" ] [ text "All done!" ],
      button [ onClick End, elemClass "action" ] [ text "OK" ]
    ]

