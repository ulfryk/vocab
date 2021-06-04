module Vocab.Base.SplashHtml exposing (..)

import Core.BEM exposing (block)
import Html exposing (Html, button, div, option, select, span, text)
import Html.Attributes exposing (disabled, value)
import Html.Events exposing (onClick, onInput)
import List exposing (length)
import Maybe exposing (withDefault)
import String exposing (fromInt)
import Vocab.Base.SplashMsg exposing (SplashMsg(..))
import Vocab.DTO.Card exposing (Card)


splash =
    block "splash"


isJust : Maybe a -> Bool
isJust m =
    case m of
        Just _ ->
            True

        Nothing ->
            False


optionsHtml : List String -> Maybe String -> List (Html SplashMsg)
optionsHtml sheets selected =
    [ option [ disabled (isJust selected) ] [ text "Select Sheet" ] ]
        ++ List.map (\sheet -> option [ value sheet ] [ text sheet ]) sheets


splashView : List String -> List Card -> Maybe String -> Html SplashMsg
splashView sheets cards selected =
    div [ splash.bl ]
        [ div [ splash.el "selector" ]
            [ select
                [ value (withDefault "" selected)
                , onInput SelectSheet
                , splash.elMod "selector-input" ( "unselected", isJust selected )
                ]
                (optionsHtml sheets selected)
            , span [ splash.el "counter" ] [ text << fromInt << length <| cards ]
            ]
        , button [ onClick <| StartGame 10, splash.el "action", disabled (length cards <= 10) ] [ text "Start 10" ]
        , button [ onClick <| StartGame 30, splash.el "action", disabled (length cards <= 30) ] [ text "Start 30" ]
        , button [ onClick StartEditing, splash.el "action" ] [ text "Manage" ]
        ]
