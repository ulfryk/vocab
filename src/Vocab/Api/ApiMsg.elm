module Vocab.Api.ApiMsg exposing (..)

import Http exposing (Error)
import Result
import Vocab.Api.DTO.SheetData exposing (SheetData, fromRawData)
import Vocab.Api.DTO.CardsDTO exposing (CardsDTO)
import Vocab.Api.DTO.SheetsDTO exposing (SheetsDataDTO, extractSheetsData)


type ApiMsg
    = GotSheets (Result Error (List String))
    | GotSheetData (Result Error SheetData)


gotSheets : Result Error SheetsDataDTO -> ApiMsg
gotSheets =
    GotSheets << Result.map extractSheetsData


gotSheetData : String -> Result Error CardsDTO -> ApiMsg
gotSheetData sheet =
    GotSheetData << Result.map (fromRawData sheet)
