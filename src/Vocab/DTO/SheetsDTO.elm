module Vocab.DTO.SheetsDTO exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias SheetPropsDTO =
    { sheetId : Int
    , title : String
    , index : Int
    }


sheetPropsDecoder : Decoder SheetPropsDTO
sheetPropsDecoder =
    D.succeed SheetPropsDTO
        |> required "sheetId" D.int
        |> required "title" D.string
        |> required "index" D.int


type alias SheetDTO =
    { properties : SheetPropsDTO
    }


sheetDecoder : Decoder SheetDTO
sheetDecoder =
    D.succeed SheetDTO
        |> required "properties" sheetPropsDecoder


type alias SheetsDataDTO =
    { spreadsheetId : String
    , sheets : List SheetDTO
    , spreadsheetUrl : String
    }


extractSheetsData : SheetsDataDTO -> List String
extractSheetsData { sheets } =
    List.map (\d -> d.properties.title) sheets


sheetsDecoder : Decoder SheetsDataDTO
sheetsDecoder =
    D.succeed SheetsDataDTO
        |> required "spreadsheetId" D.string
        |> required "sheets" (D.list sheetDecoder)
        |> required "sheets" D.string
