module Vocab.Init exposing (..)

import Core.Cmd exposing (sendMsg)
import Json.Decode as Decode
import Vocab.Model exposing (Model, initial)
import Vocab.ModelSnapshot exposing (decodeModelSnapshot)
import Vocab.Msg exposing (Msg(..))


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        data =
            Decode.decodeValue decodeModelSnapshot flags
    in
    case data of
        Ok { manage, archived } ->
            ( { initial | archived = archived, manage = manage }, sendMsg LoadData )

        Err err ->
            ( { initial | error = Just err }, Cmd.none )
