module Vocab.DTO.Creds exposing (..)

import Json.Encode as E

type alias Creds  = { apiKey: Maybe String, dataId: Maybe String }

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
