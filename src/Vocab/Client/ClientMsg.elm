module Vocab.Client.ClientMsg exposing (..)

import Http exposing (Error)
import Result exposing (map)
import Vocab.DTO.Card exposing (Card)
import Vocab.DTO.CardsDTO exposing (CardsDTO)
import Vocab.DTO.SheetsDTO exposing (SheetDTO)


type alias SheetData =
    SheetData String (List Card)


type ClientMsg
    = GotSheets (Result Error (List String))
    | GotSheetData (Result Error SheetData)


gotSheets : Result Error SheetDTO -> ClientMsg
gotSheets result =
    GotSheets <| map (\data -> data.sheets) result


gotSheetData : Result Error CardsDTO -> ClientMsg
gotSheetData result =
    GotSheetData <| map (\data -> data.values) result
