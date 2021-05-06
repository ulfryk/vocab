module Vocab.Game.DoneHtml exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import Html exposing (Attribute, Html, button, li, p, section, span, text, ul)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Set exposing (Set, size)
import String exposing (fromFloat, fromInt)
import Vocab.DTO.Card exposing (Card)
import Vocab.Game.GameModel exposing (GameStats, statsLength)
import Vocab.Game.PlayMsg exposing (PlayMsg(..))


bemTools =
    bem "all-done"


blockClass =
    getRootClass bemTools


elemClass =
    getElemClassFactory bemTools


statsBemTools =
    bem "game-stats-bar"


statsBlockClass =
    getRootClass statsBemTools


statsElemModClass =
    getElemModsClassFactory statsBemTools


statsItemClass =
    statsElemModClass "stat"


percent : GameStats -> Set String -> Attribute msg
percent allStats stat =
    style "width" <| (fromInt << round <| (toFloat (size stat) * 100) / (toFloat << statsLength <| allStats)) ++ "%"


count : Set String -> Html PlayMsg
count stat =
    if size stat == 0 then
        text ""

    else
        span [] [ text << fromInt << size <| stat ]


doneView : List Card -> GameStats -> Html PlayMsg
doneView cards stats =
    section [ blockClass ]
        [ p [ elemClass "info" ] [ text "All done!" ]
        , ul [ statsBlockClass ]
            [ li [ statsItemClass [ "perfect" ], percent stats stats.perfect ] [ count stats.perfect ]
            , li [ statsItemClass [ "good" ], percent stats stats.good ] [ count stats.good ]
            , li [ statsItemClass [ "bad" ], percent stats stats.bad ] [ count stats.bad ]
            ]
        , button [ onClick End, elemClass "action" ] [ text "OK" ]
        ]
