module Vocab.Splash.SplashViewModel exposing (..)

import Vocab.Api.DTO.Card exposing (Card)

type alias SplashViewModel =
    { cards : List Card
    , sheets : List String
    , selected : Maybe String
    }
