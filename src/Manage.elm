module Manage exposing (..)

import State exposing (Card, CardInput)

type ManageMsg = Edit | Cancel | Update CardInput | Delete String | Save Card
