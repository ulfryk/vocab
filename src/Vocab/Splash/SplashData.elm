module Vocab.Splash.SplashData exposing (..)

import Vocab.Api.DTO.Card exposing (Card)

type alias SplashData =
    { cards : List Card
    , sheets : List String
    , selected : Maybe String
    }
