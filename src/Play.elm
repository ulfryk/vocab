module Play exposing (..)

import State exposing (Card)

type PlayMsg = Start | Show Card | Next String | Drop String | SetNth Int | End
