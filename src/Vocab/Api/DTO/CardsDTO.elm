module Vocab.Api.DTO.CardsDTO exposing (..)

import Array exposing (Array, get)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Maybe exposing (withDefault)
import Vocab.Api.DTO.Card exposing (Card)


type alias CardsDTO =
    { majorDimension : String
    , range : String
    , values : List (Array String)
    }


extractCards : CardsDTO -> List (Array String)
extractCards { values } =
    values


cardsDecoder : Decoder CardsDTO
cardsDecoder =
    D.succeed CardsDTO
        |> required "majorDimension" D.string
        |> required "range" D.string
        |> required "values" (D.list (D.array D.string))


rowToCard : Array String -> Card
rowToCard row =
    { aSide = withDefault "<error>" <| get 0 row
    , bSide = withDefault "<error>" <| get 2 row
    }
