module Vocab.Init exposing (..)

import Core.Cmd exposing (sendMsg)
import Json.Decode exposing (Value, decodeValue, errorToString)
import Vocab.Model exposing (Model, decodeModel, initial)
import Vocab.Msg exposing (Msg(..))


init : Value -> ( Model, Cmd Msg )
init flags =
    case decodeValue decodeModel flags of
        Ok model ->
            ( model, sendMsg LoadData )

        Err err ->
            ( { initial | error = Just << errorToString <| err }, Cmd.none )
