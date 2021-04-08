module SplashHtml exposing (..)

import BEM exposing (bem, getElemClassFactory, getRootClass)
import Html exposing (Html, button, div, text)

import Html.Events exposing (onClick)
import SplashMsg exposing (SplashMsg(..))
import State exposing (Model)

bemTools = bem "splash"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

splashView : Model -> Html SplashMsg
splashView m =
    div [ blockClass ] [
      button [ onClick StartGame, elemClass "action" ] [ text "Start" ],
      button [ onClick StartEditing, elemClass "action" ] [ text "Manage" ]
    ]
