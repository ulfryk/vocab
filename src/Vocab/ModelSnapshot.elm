module Vocab.ModelSnapshot exposing (..)

import Array as A
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Set as S exposing (Set)
import Vocab.Manage.ManageModel exposing (ManageModel, decodeManageModel, encodeManageModel)


type alias ModelSnapshot =
    { archived : Set String
    , manage : ManageModel
    }


decodeModelSnapshot : Decoder ModelSnapshot
decodeModelSnapshot =
    D.succeed ModelSnapshot
        |> required "archived" (D.map S.fromList <| D.list D.string)
        |> required "manage" decodeManageModel


encodeModelSnapshot : ModelSnapshot -> E.Value
encodeModelSnapshot { archived, manage } =
    E.object
        [ ( "archived", E.array E.string <| A.fromList << S.toList <| archived )
        , ( "manage", encodeManageModel manage )
        ]
