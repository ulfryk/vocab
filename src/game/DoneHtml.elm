module DoneHtml exposing (..)

import Html exposing (Html, button, p, section, text)
import Html.Events exposing (onClick)

import BEM exposing (bem, getElemClassFactory, getRootClass)
import PlayMsg exposing (PlayMsg(..))
import GameModel exposing (GameStats)

bemTools = bem "all-done"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

doneView : GameStats -> Html PlayMsg
doneView m =
    section [ blockClass ] [
      p [ elemClass "info" ] [ text "All done!" ],
      button [ onClick End, elemClass "action" ] [ text "OK" ]
    ]

