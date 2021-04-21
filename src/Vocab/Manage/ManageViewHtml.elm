module Vocab.Manage.ManageViewHtml exposing (..)

import Html exposing (Html, button, footer, h4, hr, input, section, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (disabled, placeholder, value)
import Html.Events exposing (onClick, onInput)
import List exposing (map)
import Maybe exposing (withDefault)
import Set exposing (Set, member)

import String exposing (isEmpty)
import Vocab.DTO.Card exposing (Card, cardId)
import Vocab.Manage.ManageModel exposing (ManageModel)
import Vocab.Manage.ManageMsg exposing (ManageMsg(..))

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

manageView : Set String -> List Card -> ManageModel -> Html ManageMsg
manageView archived cards { apiKey, dataId } =
    section [] [
        h4 [] [ text "Edit"],
        hr [] [],
        button [ onClick Reset ] [ text "Reset" ],
        text " (it will erase all data)",
        hr [] [],
        input [ placeholder "Api Key", onInput SetApiKey, value <| withDefault "" apiKey  ] [],
        input [ placeholder "Data Id", onInput SetDataId, value <| withDefault "" dataId  ] [],
        button [onClick LoadExternalData, disabled ((isEmpty <| withDefault "" apiKey) || (isEmpty <| withDefault "" dataId)) ] [ text "Load data" ],
        hr [] [],
        table [] [
            thead [] [
                tr [] [
                    th [] [ text "A Side" ],
                    th [] [ text "B Side" ],
                    th [] [ text "Archived", button [ onClick UnArchiveAll ] [ text "Unarchive All"] ]
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
