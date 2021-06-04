module Vocab.Base.SplashHtml exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import Html exposing (Html, button, div, option, select, span, text)
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

elemModifier = getElemModsClassFactory bemTools

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
    div [ blockClass ]
        [ div [ elemClass "selector" ]
            [ select
                [ value (withDefault "" selected)
                , onInput SelectSheet
                , elemModifier "selector-input" (if isJust selected then [] else ["unselected"])
                ]
                (optionsHtml sheets selected)
            , span [ elemClass "counter" ] [ text << fromInt << length <| cards ]
            ]
        , button [ onClick <| StartGame 10, elemClass "action", disabled (length cards <= 10) ] [ text "Start 10" ]
        , button [ onClick <| StartGame 30, elemClass "action", disabled (length cards <= 30) ] [ text "Start 30" ]
        , button [ onClick StartEditing, elemClass "action" ] [ text "Manage" ]
        ]
