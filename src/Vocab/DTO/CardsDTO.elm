module Vocab.DTO.CardsDTO exposing (..)

-- https://sheets.googleapis.com/v4/spreadsheets/{id}/values/{sheet}!A:D?key=:{key}

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)


type alias CardsDTO =
    { majorDimension : String
    , range : String
    , values : List (List String)
    }


cardsDecoder : Decoder CardsDTO
cardsDecoder =
    D.succeed CardsDTO
        |> required "majorDimension" D.string
        |> required "range" D.string
        |> required "values" (D.list (D.list D.string))
