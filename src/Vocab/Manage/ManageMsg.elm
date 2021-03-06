module Vocab.Manage.ManageMsg exposing (..)

import Vocab.Api.DTO.Card exposing (Card)


type ManageMsg
    = Done
    | ToggleArchived Bool Card
    | UnArchiveAll
    | SetApiKey String
    | SetDataId String
    | Save
    | Reset
