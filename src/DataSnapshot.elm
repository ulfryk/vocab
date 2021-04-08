module DataSnapshot exposing (..)

import Array as A
import Json.Encode as E exposing (Value)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Set as S exposing (Set)

import GameModel exposing (Card)

type alias DataSnapshot = {
  cards: List Card,
  archived: Set String }

cardDecoder : Decoder Card
cardDecoder =
    D.succeed Card
      |> required "aSide" D.string
      |> required "bSide" D.string

cardEncoder : Card -> Value
cardEncoder { aSide, bSide } =
    E.object [
        ( "aSide", E.string aSide),
        ("bSide", E.string bSide )]

dataSnapshotDecoder : Decoder DataSnapshot
dataSnapshotDecoder =
    D.succeed DataSnapshot
        |> required "cards" (D.list cardDecoder)
        |> required "archived" (D.map S.fromList <| D.list D.string)


dataSnapshotEncoder : DataSnapshot -> Value
dataSnapshotEncoder { cards, archived } =
    E.object [
    ( "cards", E.array cardEncoder <| A.fromList cards ),
    ( "archived", E.array E.string <| A.fromList << S.toList <| archived )]

