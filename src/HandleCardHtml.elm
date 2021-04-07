module HandleCardHtml exposing (..)

import BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import DoneHtml exposing (doneView)
import Html exposing (Html, button, div, p, span, text)
import Html.Events exposing (onClick)

import Play exposing (PlayMsg(..))
import GameModel exposing (Card, Current(..), GameStats, Showing(..), cardId)

bemTools = bem "word-card"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

pairBemTools = bem "words-pair"
pairClass = getRootClass pairBemTools
pairElemModClass = getElemModsClassFactory pairBemTools

actionsBemTools = bem "word-actions"
actionsClass = getRootClass actionsBemTools
actionsElemModClass = getElemModsClassFactory actionsBemTools

handleCard : GameStats -> Html PlayMsg
handleCard ({ current } as game) =
    case current of
      GameModel.Answer card ->
        div [ blockClass ] [
          p [ elemClass "pair", pairClass ] [
            span [ pairElemModClass "word" ["left"] ] [ text card.aSide ] ,
            span [ pairElemModClass "word" ["right"] ] [ text card.bSide ]

          ],
          div [ elemClass "actions", actionsClass ] [
            button [ onClick (Drop <| cardId card), actionsElemModClass "action" ["perfect"] ] [ text "perfect" ],
            button [ onClick (Next <| cardId card), actionsElemModClass "action" ["good"]  ] [ text "good" ],
            button [ onClick (Fail <| cardId card), actionsElemModClass "action" ["fail"] ] [ text "No Idea! :(" ]
          ]
        ]
      GameModel.Question side card -> case side of
        ASide ->
          div [ blockClass ] [
            p [ elemClass "pair", pairClass ] [
              span [ pairElemModClass "word" ["left"] ] [ text card.aSide ] ,
              span [ pairElemModClass "word" ["right"] ] [ button [ onClick (Show card) ] [ text "? ? ?"] ]
            ],
            div [ elemClass "actions", actionsClass ] []
          ]
        BSide ->
          div [ blockClass ] [
            p [ elemClass "pair", pairClass ] [
              span [ pairElemModClass "word" ["left"] ] [ button [ onClick (Show card) ] [ text "? ? ?"] ],
              span [ pairElemModClass "word" ["right"] ] [ text card.bSide ]
            ],
            div [ elemClass "actions", actionsClass ] []
          ]
      GameModel.NoMoreCards -> doneView game

