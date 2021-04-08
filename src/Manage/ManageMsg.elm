module Manage.ManageMsg exposing (..)

import Card exposing (Card)

type ManageMsg = Done | ToggleArchived Bool Card
