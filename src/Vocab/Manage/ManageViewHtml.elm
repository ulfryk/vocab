module Vocab.Manage.ManageViewHtml exposing (..)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, br, button, footer, h4, hr, input, label, option, section, select, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, disabled, placeholder, style, value)
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
        True ->
            "archived: "

        False ->
            "available: "


cardActionText : Bool -> String
cardActionText value =
    case value of
        True ->
            "Unarchive"

        False ->
            "Archive"


isCardArchived : Set String -> Card -> Bool
isCardArchived archived card =
    member (cardId card) <| archived


cardState : Set String -> Card -> List (Html ManageMsg)
cardState archived card =
    let
        isArchived =
            isCardArchived archived card
    in
    [ text <| cardStateText isArchived
    , button [ onClick <| ToggleArchived (not isArchived) card ] [ text <| cardActionText isArchived ]
    ]


lineClass : Set String -> Card -> Attribute msg
lineClass a c =
    if isCardArchived a c then
        class "archived"

    else
        class "available"


manageView : Set String -> List Card -> ManageModel -> Html ManageMsg
manageView archived cards { apiKey, dataId } =
    section []
        [ h4 [] [ text "Edit", button [ onClick Done, style "float" "right" ] [ text "back" ] ]
        , hr [] []
        , button [ onClick Reset ] [ text "Reset" ]
        , text " (it will erase all data)"
        , hr [] []
        , br [] []
        , label [] [ text "Api Key: " ]
        , input [ placeholder "Enter Api Key…", onInput SetApiKey, value <| withDefault "" apiKey ] []
        , br [] []
        , br [] []
        , label [] [ text "SpreadSheet ID " ]
        , input [ placeholder "Enter SpreadSheet ID…", onInput SetDataId, value <| withDefault "" dataId ] []
        , br [] []
        , br [] []
        , button [ onClick Save ] [ text "Save Creds" ]
        , hr [] []
        , table []
            [ thead []
                [ tr []
                    [ th [] [ text "A Side" ]
                    , th [] [ text "B Side" ]
                    , th [] [ text "Archived", button [ onClick UnArchiveAll ] [ text "Unarchive All" ] ]
                    ]
                ]
            , tbody [] <|
                map
                    (\c ->
                        tr [ lineClass archived c ]
                            [ td [] [ text c.aSide ]
                            , td [] [ text c.bSide ]
                            , td [] << cardState archived <| c
                            ]
                    )
                    cards
            ]
        , footer [] [ button [ onClick Done ] [ text "done" ] ]
        ]
