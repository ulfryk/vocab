module HandleCardHtml exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
import Play exposing (PlayMsg(..))
import State exposing (Card)

handleCard : Bool -> Card -> Html PlayMsg
handleCard show card =
        if show then
          div [] [
            p [] [ text card.bSide ],
            button [ onClick (Next card.id)  ] [ text "next" ],
            button [ onClick (Drop card.id) ] [ text "archive" ]
          ]
        else
          div [] [
            p [] [ text card.aSide ],
            button [ onClick (Show card) ] [ text "show"]
          ]
