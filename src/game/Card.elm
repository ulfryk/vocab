module Card exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E

type alias Card = { aSide: String, bSide: String }

cardId : Card -> String
cardId { aSide, bSide } = aSide ++ ":" ++ bSide

cardDecoder : Decoder Card
cardDecoder =
    D.succeed Card
      |> required "aSide" D.string
      |> required "bSide" D.string

encodeCard : Card -> E.Value
encodeCard { aSide, bSide } =
    E.object [
        ( "aSide", E.string aSide),
        ( "bSide", E.string bSide )]
