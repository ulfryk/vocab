module Vocab.Game.DoneHtml exposing (..)

import Html exposing (Html, button, p, section, text)
import Html.Events exposing (onClick)
import Core.BEM exposing (bem, getElemClassFactory, getRootClass)

import Vocab.Game.PlayMsg exposing (PlayMsg(..))
import Vocab.Game.GameModel exposing (GameStats)


bemTools = bem "all-done"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

doneView : GameStats -> Html PlayMsg
doneView m =
    section [ blockClass ] [
      p [ elemClass "info" ] [ text "All done!" ],
      button [ onClick End, elemClass "action" ] [ text "OK" ]
    ]

