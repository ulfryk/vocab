module Manage.ManageViewHtml exposing (..)

import Html exposing (Html, button, footer, h4, section, table, tbody, td, text, th, thead, tr)
import Html.Events exposing (onClick)
import List exposing (map)
import Set exposing (Set, member)

import Vocab.DTO.Card exposing (Card, cardId)
import Manage.ManageMsg exposing (ManageMsg(..))

cardStateText : Bool -> String
cardStateText value =
  case value of
     True -> "archived: "
     False -> "available: "

cardActionText : Bool -> String
cardActionText value =
  case value of
     True -> "Unarchive"
     False -> "Archive"

cardState : Set String -> Card -> List (Html ManageMsg)
cardState archived card =
    let isArchived = member (cardId card) <| archived in
    [
        text <| cardStateText isArchived,
        button [ onClick <| ToggleArchived (not isArchived ) card ] [ text <| cardActionText isArchived ]
    ]

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
                    td [] << cardState archived <| c
                ]
            ) cards
        ],
        footer [] [ button [ onClick Done ] [ text "done"] ]
    ]
