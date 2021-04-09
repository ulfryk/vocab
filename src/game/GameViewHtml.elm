module GameViewHtml exposing (..)

import Vocab.DTO.Card exposing (cardId)
import Html exposing (Html, button, div, p, span, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)

import BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import DoneHtml exposing (doneView)
import PlayMsg exposing (PlayMsg(..))
import GameModel exposing (Current(..), GameStats, Showing(..))

bemTools = bem "word-card"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

pairBemTools = bem "words-pair"
pairClass = getRootClass pairBemTools
pairElemModClass = getElemModsClassFactory pairBemTools

actionsBemTools = bem "word-actions"
actionsClass = getRootClass actionsBemTools
actionsElemModClass = getElemModsClassFactory actionsBemTools

actionsView d card =
          div [ elemClass "actions", actionsClass ] [
            button [ disabled d, onClick (Drop <| cardId card), actionsElemModClass "action" ["perfect"] ] [ text "perfect" ],
            button [ disabled d, onClick (Next <| cardId card), actionsElemModClass "action" ["good"]  ] [ text "good" ],
            button [ disabled d, onClick (Fail <| cardId card), actionsElemModClass "action" ["fail"] ] [ text "No Idea! :(" ]
          ]

gameView : GameStats -> Html PlayMsg
gameView ({ current } as game) = case current of
      GameModel.Answer card ->
        div [ blockClass ] [
          p [ elemClass "pair", pairClass ] [
            span [ pairElemModClass "word" ["left"] ] [ text card.aSide ] ,
            span [ pairElemModClass "word" ["right"] ] [ text card.bSide ]
          ],
          actionsView False card
        ]
      GameModel.Question side card -> case side of
        ASide ->
          div [ blockClass ] [
            p [ elemClass "pair", pairClass ] [
              span [ pairElemModClass "word" ["left"] ] [ text card.aSide ] ,
              span [ pairElemModClass "word" ["right"] ] [ button [ onClick (Show card) ] [ text "? ? ?"] ]
            ],
             actionsView True card
          ]
        BSide ->
          div [ blockClass ] [
            p [ elemClass "pair", pairClass ] [
              span [ pairElemModClass "word" ["left"] ] [ button [ onClick (Show card) ] [ text "? ? ?"] ],
              span [ pairElemModClass "word" ["right"] ] [ text card.bSide ]
            ],
            actionsView True card
          ]
      GameModel.NoMoreCards -> doneView game

