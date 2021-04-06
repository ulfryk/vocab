module Manage exposing (..)

import State exposing (Card)

type ManageMsg = Edit | Cancel | Update Card | Delete String | Save Card
