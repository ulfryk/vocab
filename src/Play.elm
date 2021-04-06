module Play exposing (..)

import State exposing (Card)

type PlayMsg = Start | Show Card | Fail String | Next String | Drop String | SetNth Int | End
