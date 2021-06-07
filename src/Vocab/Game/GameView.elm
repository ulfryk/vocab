module Vocab.Game.GameView exposing (..)

import Core.BEM exposing (block)
import Html exposing (Html, button, div, p, small, span, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Vocab.Api.DTO.Card exposing (Card, cardId)
import Vocab.Game.DoneView exposing (doneView)
import Vocab.Game.GameModel exposing (Current(..), GameModel, Showing(..))
import Vocab.Game.GameMsg exposing (GameMsg(..))


wordCard =
    block "word-card"


wordPair =
    block "words-pair"


wordActions =
    block "word-actions"


actionsView d card =
    div [ wordCard.el "actions", wordActions.bl ]
        [ button [ disabled d, onClick (Drop <| cardId card), wordActions.elMod "action" ( "perfect", True ) ] [ text " OK! ", small [] [ text " (hide) " ] ]
        , button [ disabled d, onClick (Next <| cardId card), wordActions.elMod "action" ( "good", True ) ] [ text " Good ", small [] [ text " (keep) " ] ]
        , button [ disabled d, onClick (Fail <| cardId card), wordActions.elMod "action" ( "fail", True ) ] [ text " No Idea… ", small [] [ text " (keep) " ] ]
        ]


gameView : GameModel -> Html GameMsg
gameView ({ current, countDown } as game) =
    if countDown == 0 then
        doneView game

    else
        case current of
            NoMoreCards ->
                doneView game

            Answer card ->
                div [ wordCard.bl ]
                    [ p [ wordCard.el "pair", wordPair.bl ]
                        [ span [ wordPair.elMod "word" ( "left", True ) ] [ text card.aSide ]
                        , span [ wordPair.elMod "word" ( "right", True ) ] [ text card.bSide ]
                        ]
                    , actionsView False card
                    ]

            Question side card ->
                case side of
                    ASide ->
                        div [ wordCard.bl ]
                            [ p [ wordCard.el "pair", wordPair.bl ]
                                [ span [ wordPair.elMod "word" ( "left", True ) ] [ text card.aSide ]
                                , span [ wordPair.elMod "word" ( "right", True ) ] [ button [ onClick (Show card) ] [ text "? ? ?" ] ]
                                ]
                            , actionsView True card
                            ]

                    BSide ->
                        div [ wordCard.bl ]
                            [ p [ wordCard.el "pair", wordPair.bl ]
                                [ span [ wordPair.elMod "word" ( "left", True ) ] [ button [ onClick (Show card) ] [ text "? ? ?" ] ]
                                , span [ wordPair.elMod "word" ( "right", True ) ] [ text card.bSide ]
                                ]
                            , actionsView True card
                            ]
