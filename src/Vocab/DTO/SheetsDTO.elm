module Vocab.DTO.SheetsDTO exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias SheetDTO =
    { spreadsheetId : String
    , sheets : List String
    , spreadsheetUrl : String
    }

extractSheetsData : SheetDTO -> List String
extractSheetsData { sheets } = sheets

sheetsDecoder : Decoder SheetDTO
sheetsDecoder =
    D.succeed SheetDTO
        |> required "spreadsheetId" D.string
        |> required "sheets" (D.list D.string)
        |> required "sheets" D.string
