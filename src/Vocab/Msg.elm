module Vocab.Msg exposing (..)

import Http
import Json.Decode as Decode
import Vocab.Api.ApiMsg exposing (ApiMsg(..))
import Vocab.Api.DTO.Card exposing (Card)
import Vocab.Game.GameMsg exposing (GameMsg(..))
import Vocab.Manage.ManageMsg exposing (ManageMsg(..))
import Vocab.Splash.SplashMsg exposing (SplashMsg(..))


type Msg
    = Play GameMsg
    | Manage ManageMsg
    | Basic SplashMsg
    | Loaded String (List Card)
    | Errored Decode.Error
    | ApiFailed Http.Error
    | Api ApiMsg
    | LoadData
