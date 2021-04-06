module HandleCardHtml exposing (..)

import BEM exposing (bem, getElemClassFactory, getElemModsClassFactory, getRootClass)
import Html exposing (Html, button, div, p, span, text)
import Html.Events exposing (onClick)

import Play exposing (PlayMsg(..))
import State exposing (Card, Showing(..), cardId)

bemTools = bem "word-card"
blockClass = getRootClass bemTools
elemClass = getElemClassFactory bemTools

pairBemTools = bem "words-pair"
pairClass = getRootClass pairBemTools
pairElemModClass = getElemModsClassFactory pairBemTools

handleCard : Showing -> Card -> Html PlayMsg
handleCard show card =
    case show of
      Both ->
        div [ blockClass ] [
          p [ elemClass "pair", pairClass ] [
            text (card.aSide ++ " --> " ++ card.bSide)
          ],
          button [ onClick (Drop <| cardId card)  ] [ text "perfect" ],
          button [ onClick (Next <| cardId card)  ] [ text "good" ],
          button [ onClick (Fail <| cardId card) ] [ text "No Idea! :(" ]
        ]
      ASide ->
        div [ blockClass ] [
          p [ elemClass "pair", pairClass ] [
            span [ pairElemModClass "word" ["left"] ] [ text card.aSide ] ,
            span [ pairElemModClass "word" ["right"] ] [ button [ onClick (Show card) ] [ text "show"] ]
          ]
        ]
      BSide ->
        div [ blockClass ] [
          p [ elemClass "pair", pairClass ] [
            button [ onClick (Show card) ] [ text "show"],
            text (" --> " ++ card.bSide)
          ]
        ]
