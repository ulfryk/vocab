module Vocab.DTO.DataSnapshot exposing (..)

import Array as A
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Set as S exposing (Set)
import Vocab.DTO.Creds exposing (Creds, credsDecoder, encodeCreds)


type alias DataSnapshot =
    { archived : Set String
    , creds : Creds
    }


dataSnapshotDecoder : Decoder DataSnapshot
dataSnapshotDecoder =
    D.succeed DataSnapshot
        |> required "archived" (D.map S.fromList <| D.list D.string)
        |> required "creds" credsDecoder


encodeDataSnapshot : DataSnapshot -> E.Value
encodeDataSnapshot { archived, creds } =
    E.object
        [ ( "archived", E.array E.string <| A.fromList << S.toList <| archived )
        , ( "creds", encodeCreds creds )
        ]
