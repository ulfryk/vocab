module Vocab.Api.DTO.SheetData exposing (..)

import Vocab.Api.DTO.Card exposing (Card)
import Vocab.Api.DTO.CardsDTO exposing (CardsDTO, extractCards, rowToCard)


type SheetData
    = SheetData String (List Card)


fromRawData : String -> CardsDTO -> SheetData
fromRawData z =
    SheetData z << List.map rowToCard << extractCards
