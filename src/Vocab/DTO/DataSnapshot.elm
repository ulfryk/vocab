module Vocab.DTO.DataSnapshot exposing (..)

import Array as A
import Set as S exposing (Set)
import Json.Encode as E
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)

import Vocab.DTO.Card exposing (Card, cardDecoder, encodeCard)

type alias DataSnapshot = {
  cards: List Card,
  archived: Set String }


dataSnapshotDecoder : Decoder DataSnapshot
dataSnapshotDecoder =
    D.succeed DataSnapshot
        |> required "cards" (D.list cardDecoder)
        |> required "archived" (D.map S.fromList <| D.list D.string)

encodeDataSnapshot : DataSnapshot -> E.Value
encodeDataSnapshot { cards, archived } =
    E.object [
    ( "cards", E.array encodeCard <| A.fromList cards ),
    ( "archived", E.array E.string <| A.fromList << S.toList <| archived )]

