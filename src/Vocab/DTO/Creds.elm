module Vocab.DTO.Creds exposing (..)

import Json.Encode as E
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (optional)

type alias Creds  = { apiKey: Maybe String, dataId: Maybe String }

credsDecoder : Decoder Creds
credsDecoder =
    D.succeed Creds
        |> optional "apiKey" (D.maybe D.string) Nothing
        |> optional "dataId" (D.maybe D.string) Nothing

encodeCreds : Creds -> E.Value
encodeCreds { apiKey, dataId } =
    E.object [
        ("apiKey", case apiKey of
            Just key -> E.string key
            Nothing -> E.null
        ),
        ("dataId", case dataId of
            Just id -> E.string id
            Nothing -> E.null
        )
    ]
