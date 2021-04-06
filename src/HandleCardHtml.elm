module HandleCardHtml exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
import Play exposing (PlayMsg(..))
import State exposing (Card, Showing(..), cardId)

handleCard : Showing -> Card -> Html PlayMsg
handleCard show card =
        case show of
          Both ->
            div [] [
              p [] [ text (card.aSide ++ " --> " ++ card.bSide) ],
              button [ onClick (Drop <| cardId card)  ] [ text "perfect" ],
              button [ onClick (Next <| cardId card)  ] [ text "good" ],
              button [ onClick (Fail <| cardId card) ] [ text "No Idea! :(" ]
            ]
          ASide ->
            div [] [
              p [] [ text (card.aSide ++ " --> "), button [ onClick (Show card) ] [ text "show"] ]
            ]
          BSide ->
            div [] [
              p [] [ button [ onClick (Show card) ] [ text "show"], text (" --> " ++ card.bSide)  ]
            ]
