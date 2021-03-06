module Vocab.Splash.SplashView exposing (..)

import Core.BEM exposing (block)
import Html exposing (Attribute, Html, button, div, option, pre, select, span, text)
import Html.Attributes exposing (attribute, default, disabled, value)
import Html.Events exposing (onClick, onInput)
import List exposing (length)
import Maybe exposing (withDefault)
import String exposing (fromInt, isEmpty)
import Vocab.Splash.SplashMsg exposing (SplashMsg(..))
import Vocab.Splash.SplashViewModel exposing (SplashViewModel)


splash =
    block "splash"


isEmpty : Maybe String -> Bool
isEmpty m =
    case m of
        Just s ->
            s == ""

        Nothing ->
            True


optionAttrs : String -> String -> List (Attribute msg)
optionAttrs selected sheet =
    if selected == sheet then
        [ value sheet, attribute "selected" "selected" ]

    else
        [ value sheet ]


optionsHtml : String -> List String -> List (Html SplashMsg)
optionsHtml selected sheets =
    [ option
        ([ disabled True
         , attribute "default" "default"
         , default True
         ]
            ++ optionAttrs selected "--"
        )
        [ text "Select Sheet" ]
    ]
        ++ List.map (\sheet -> option (optionAttrs selected sheet) [ text sheet ]) sheets


splashView : SplashViewModel -> Html SplashMsg
splashView { sheets, cards, selected } =
    div [ splash.bl ]
        [ div [ splash.el "selector" ]
            [ select
                [ value (withDefault "--" selected)
                , onInput SelectSheet
                , splash.elMod "selector-input" ( "unselected", isEmpty selected )
                ]
                (optionsHtml (withDefault "--" selected) sheets)
            , span [ splash.el "counter" ] [ text << fromInt << length <| cards ]
            ]
        , button [ onClick <| StartGame 10, splash.el "action", disabled (length cards <= 10) ] [ text "Start 10" ]
        , button [ onClick <| StartGame 30, splash.el "action", disabled (length cards <= 30) ] [ text "Start 30" ]
        , button [ onClick StartEditing, splash.el "action" ] [ text "Manage" ]
        ]
