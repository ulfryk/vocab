module Vocab.Game.GameViewHtml exposing (..)

import Core.BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import Html exposing (Html, button, div, p, small, span, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Vocab.DTO.Card exposing (Card, cardId)
import Vocab.Game.DoneHtml exposing (doneView)
import Vocab.Game.GameModel exposing (Current(..), GameStats, Showing(..))
import Vocab.Game.PlayMsg exposing (PlayMsg(..))


bemTools =
    bem "word-card"


blockClass =
    getRootClass bemTools


elemClass =
    getElemClassFactory bemTools


pairBemTools =
    bem "words-pair"


pairClass =
    getRootClass pairBemTools


pairElemModClass =
    getElemModsClassFactory pairBemTools


actionsBemTools =
    bem "word-actions"


actionsClass =
    getRootClass actionsBemTools


actionsElemModClass =
    getElemModsClassFactory actionsBemTools


actionsView d card =
    div [ elemClass "actions", actionsClass ]
        [ button [ disabled d, onClick (Drop <| cardId card), actionsElemModClass "action" [ "perfect" ] ] [ text " OK! ", small [] [ text " (hide) " ] ]
        , button [ disabled d, onClick (Next <| cardId card), actionsElemModClass "action" [ "good" ] ] [ text " Good ", small [] [ text " (keep) " ] ]
        , button [ disabled d, onClick (Fail <| cardId card), actionsElemModClass "action" [ "fail" ] ] [ text " No Idea… ", small [] [ text " (keep) " ] ]
        ]


gameView : List Card -> GameStats -> Html PlayMsg
gameView cards ({ current, countDown } as game) =
    if countDown == 0 then
        doneView cards game

    else
        case current of
            Answer card ->
                div [ blockClass ]
                    [ p [ elemClass "pair", pairClass ]
                        [ span [ pairElemModClass "word" [ "left" ] ] [ text card.aSide ]
                        , span [ pairElemModClass "word" [ "right" ] ] [ text card.bSide ]
                        ]
                    , actionsView False card
                    ]

            Question side card ->
                case side of
                    ASide ->
                        div [ blockClass ]
                            [ p [ elemClass "pair", pairClass ]
                                [ span [ pairElemModClass "word" [ "left" ] ] [ text card.aSide ]
                                , span [ pairElemModClass "word" [ "right" ] ] [ button [ onClick (Show card) ] [ text "? ? ?" ] ]
                                ]
                            , actionsView True card
                            ]

                    BSide ->
                        div [ blockClass ]
                            [ p [ elemClass "pair", pairClass ]
                                [ span [ pairElemModClass "word" [ "left" ] ] [ button [ onClick (Show card) ] [ text "? ? ?" ] ]
                                , span [ pairElemModClass "word" [ "right" ] ] [ text card.bSide ]
                                ]
                            , actionsView True card
                            ]

            NoMoreCards ->
                doneView cards game
