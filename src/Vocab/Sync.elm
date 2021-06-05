port module Vocab.Sync exposing (..)

import Json.Encode as Encode
import Vocab.Model exposing (Model, encodeModel)
import Vocab.Msg exposing (Msg)


port syncData : Encode.Value -> Cmd msg


sync : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
sync ( { cards, archived, manage } as model, command ) =
    ( model
    , Cmd.batch
        [ syncData <| encodeModel model, command ]
    )
