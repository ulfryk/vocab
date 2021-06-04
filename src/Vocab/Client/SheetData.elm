module Vocab.Client.SheetData exposing (..)

import Vocab.DTO.Card exposing (Card)
import Vocab.DTO.CardsDTO exposing (CardsDTO, extractCards, rowToCard)


type SheetData
    = SheetData String (List Card)


fromRawData : String -> CardsDTO -> SheetData
fromRawData z =
    SheetData z << List.map rowToCard << extractCards
