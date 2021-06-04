module Vocab.Base.SplashHtml exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getRootClass)
import Html exposing (Html, button, div, hr, option, select, span, text)
import Html.Attributes exposing (disabled, value)
import Html.Events exposing (onClick, onInput)
import List exposing (length)
import Maybe exposing (withDefault)
import String exposing (fromInt)
import Vocab.Base.SplashMsg exposing (SplashMsg(..))
import Vocab.DTO.Card exposing (Card)


bemTools =
    bem "splash"


blockClass =
    getRootClass bemTools


elemClass =
    getElemClassFactory bemTools


splashView : List String -> List Card -> Maybe String -> Html SplashMsg
splashView sheets cards selected =
    div [ blockClass ]
        [ div [ elemClass "selector" ]
            [ select
                [ value (withDefault "" selected)
                , onInput SelectSheet
                , elemClass "selector-input"
                ]
              <|
                [ option [] [ text "Select Sheet" ] ]
                    ++ List.map (\sheet -> option [ value sheet ] [ text sheet ]) sheets
            , span [ elemClass "counter" ] [ text << fromInt << length <| cards ]
            ]
        , button [ onClick <| StartGame 10, elemClass "action", disabled (length cards <= 10) ] [ text "Start 10" ]
        , button [ onClick <| StartGame 30, elemClass "action", disabled (length cards <= 30) ] [ text "Start 30" ]
        , button [ onClick StartEditing, elemClass "action" ] [ text "Manage" ]
        ]
