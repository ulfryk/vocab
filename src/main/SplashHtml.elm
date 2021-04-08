module SplashHtml exposing (..)

import BEM exposing (bem, getElemClassFactory, getRootClass)
import Html exposing (Html, button, div, text)

import Html.Events exposing (onClick)
import PlayMsg exposing (PlayMsg(..))
import State exposing (Model)

bemTools = bem "splash"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

splashView : Model -> Html PlayMsg
splashView m =
    div [ blockClass ] [
      button [ onClick Start, elemClass "start" ] [ text "start"]
    ]
