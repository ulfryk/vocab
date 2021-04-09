module Vocab.Base.SplashHtml exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Core.BEM exposing (bem, getElemClassFactory, getRootClass)

import Vocab.Base.SplashMsg exposing (SplashMsg(..))

bemTools = bem "splash"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

splashView : () -> Html SplashMsg
splashView _ =
    div [ blockClass ] [
      button [ onClick StartGame, elemClass "action" ] [ text "Start" ],
      button [ onClick StartEditing, elemClass "action" ] [ text "Manage" ]
    ]
