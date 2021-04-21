module Vocab.DTO.GoogleSheetData exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import List exposing (map)
import Vocab.DTO.Card exposing (Card)

type alias GoogleSheetData = {
    majorDimension : String,
    range: String,
    values: List Card
    }

lstAsCard : List String -> Card
lstAsCard lst = case lst of
    aSide :: _ :: bSide :: _ -> Card aSide bSide
    aSide :: _  -> Card aSide ""
    _ -> Card "" ""

gooShtDecoder : Decoder GoogleSheetData
gooShtDecoder =
    D.succeed GoogleSheetData
        |> required "majorDimension" D.string
        |> required "range" D.string
        |> required "values" ( D.map (map lstAsCard) <| D.list (D.list D.string) )
