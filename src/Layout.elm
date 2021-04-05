module Layout exposing (..)

import Debug exposing (toString)
import Html exposing (Attribute, Html, div, footer, h1, h3, header, main_, p, small, text)
import Html.Attributes exposing (class, style)
import List exposing (length)
import State exposing (Model, getAvailableCards)

blockCls = "layout"

elemClass : String -> Attribute msg
elemClass name = class (blockCls ++ "__" ++ name)

progress : Model -> String
progress m =
    let total = length m.cards
        done = length << getAvailableCards <| m
        amount = toString <| (done * 100) // total
    in
    amount ++ "%"


layout : Model -> List (Html a) -> Html a
layout model content =
  div [ class blockCls ] [
    header [ elemClass "header" ] [
      h1 [ elemClass "heading"] [
        text "Vocab ",
        small [] [text ("(" ++(toString model.next) ++")")]
      ],
      h3 [ elemClass "info"] [ text "Learn the words!" ]
    ],
    main_ [ elemClass "main" ] content,
    footer [ elemClass "footer" ] [ text "© Ulfryk 2021" ],
    div [ elemClass "progress", style "bottom" <| progress model ] []
    ]
