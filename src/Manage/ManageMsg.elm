module Manage.ManageMsg exposing (..)

import Vocab.DTO.Card exposing (Card)

type ManageMsg = Done | ToggleArchived Bool Card
