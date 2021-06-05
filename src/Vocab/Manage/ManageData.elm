module Vocab.Manage.ManageData exposing (..)

import Set exposing (Set)
import Vocab.Api.DTO.Card exposing (Card)
import Vocab.Manage.ManageModel exposing (ManageModel)


type alias ManageData =
    { archived : Set String
    , cards : List Card
    , model : ManageModel
    }
