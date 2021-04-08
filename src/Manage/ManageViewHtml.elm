module Manage.ManageViewHtml exposing (..)

import Html exposing (Html, button, footer, h4, section, table, tbody, td, text, th, thead, tr)
import Html.Events exposing (onClick)
import List exposing (map)
import Manage.ManageMsg exposing (ManageMsg(..))
import Card exposing (Card, cardId)
import Set exposing (Set, member)

stringFromBool : Bool -> String
stringFromBool value =
  case value of
     True -> "True"
     False -> "False"

manageView : Set String -> List Card -> Html ManageMsg
manageView archived cards =
    section [] [
        h4 [] [ text "Edit"],
        table [] [
            thead [] [
                tr [] [
                    th [] [ text "A Side" ],
                    th [] [ text "B Side" ],
                    th [] [ text "Archived" ]
                ]
            ],
            tbody [] <| map ( \c ->
                tr [] [
                    td [] [ text c.aSide ],
                    td [] [ text c.bSide ],
                    td [] [ text << stringFromBool << member (cardId c) <| archived ]
                ]
            ) cards
        ],
        footer [] [ button [ onClick Done ] [ text "done"] ]
    ]
