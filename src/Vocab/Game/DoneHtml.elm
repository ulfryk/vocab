module Vocab.Game.DoneHtml exposing (..)

import Core.BEM exposing (block)
import Html exposing (Attribute, Html, button, li, p, section, span, text, ul)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Set exposing (Set, size)
import String exposing (fromInt)
import Vocab.Game.GameModel exposing (GameModel, statsLength)
import Vocab.Game.GameMsg exposing (GameMsg(..))


allDone =
    block "all-done"


statsBar =
    block "game-stats-bar"


percent : GameModel -> Set String -> Attribute msg
percent allStats stat =
    style "width" <| (fromInt << round <| (toFloat (size stat) * 100) / (toFloat << statsLength <| allStats)) ++ "%"


count : Set String -> Html GameMsg
count stat =
    if size stat == 0 then
        text ""

    else
        span [] [ text << fromInt << size <| stat ]


doneView : GameModel -> Html GameMsg
doneView stats =
    section [ allDone.bl ]
        [ p [ allDone.el "info" ] [ text "All done!" ]
        , ul [ statsBar.bl ]
            [ li [ statsBar.elMod "stat" ( "perfect", True ), percent stats stats.perfect ] [ count stats.perfect ]
            , li [ statsBar.elMod "stat" ( "good", True ), percent stats stats.good ] [ count stats.good ]
            , li [ statsBar.elMod "stat" ( "bad", True ), percent stats stats.bad ] [ count stats.bad ]
            ]
        , button [ onClick End, allDone.el "action" ] [ text "OK" ]
        ]
