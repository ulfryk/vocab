module Manage exposing (..)

import GameModel exposing (Card)

type ManageMsg = Edit | Cancel | Update Card | Delete String | Save Card
