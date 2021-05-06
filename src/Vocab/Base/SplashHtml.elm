module Vocab.Base.SplashHtml exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getRootClass)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Vocab.Base.SplashMsg exposing (SplashMsg(..))


bemTools =
    bem "splash"


blockClass =
    getRootClass bemTools


elemClass =
    getElemClassFactory bemTools


splashView : () -> Html SplashMsg
splashView _ =
    div [ blockClass ]
        [ button [ onClick <| StartGame 10, elemClass "action" ] [ text "Start 10" ]
        , button [ onClick <| StartGame 30, elemClass "action" ] [ text "Start 30" ]
        , button [ onClick StartEditing, elemClass "action" ] [ text "Manage" ]
        ]
