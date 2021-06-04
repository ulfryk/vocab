module Vocab.Client.ClientMsg exposing (..)

import Http exposing (Error)
import Result
import Vocab.Client.SheetData exposing (SheetData, fromRawData)
import Vocab.DTO.CardsDTO exposing (CardsDTO)
import Vocab.DTO.SheetsDTO exposing (SheetDTO, extractSheetsData)


type ClientMsg
    = GotSheets (Result Error (List String))
    | GotSheetData (Result Error SheetData)


gotSheets : Result Error SheetDTO -> ClientMsg
gotSheets =
    GotSheets << Result.map extractSheetsData


gotSheetData : String -> Result Error CardsDTO -> ClientMsg
gotSheetData sheet =
    GotSheetData << Result.map (fromRawData sheet)
