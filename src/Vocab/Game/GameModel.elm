module Vocab.Game.GameModel exposing (..)

import Array as A
import Json.Decode as D
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as E
import Set as S exposing (Set, empty, size)
import Vocab.Api.DTO.Card exposing (Card, cardDecoder, encodeCard)


type Showing
    = ASide
    | BSide


encodeShowing : Showing -> E.Value
encodeShowing showing =
    case showing of
        ASide ->
            E.string "ASide"

        BSide ->
            E.string "BSide"


decodeShowing : String -> D.Decoder Showing
decodeShowing tag =
    case tag of
        "ASide" ->
            D.succeed ASide

        "BSide" ->
            D.succeed BSide

        _ ->
            D.fail (tag ++ " is not a recognized tag for Showing")


type Current
    = Question Showing Card
    | Answer Card
    | NoMoreCards


extractAndDecodeCard : D.Decoder Card
extractAndDecodeCard =
    D.field "card" cardDecoder


decodeCurrentType : D.Decoder String
decodeCurrentType =
    D.field "type" D.string


chooseByType : String -> D.Decoder Current
chooseByType ttype =
    case ttype of
        "Question" ->
            D.field "showing" D.string
                |> D.andThen decodeShowing
                |> D.andThen (\show -> D.map (Question show) extractAndDecodeCard)

        "Answer" ->
            D.map Answer extractAndDecodeCard

        "NoMoreCards" ->
            D.succeed NoMoreCards

        _ ->
            D.fail ("Invalid user type: " ++ ttype)


decodeCurrent : D.Decoder Current
decodeCurrent =
    D.andThen chooseByType decodeCurrentType


encodeCurrent : Current -> E.Value
encodeCurrent current =
    case current of
        Question showing card ->
            E.object
                [ ( "type", "Question" |> E.string )
                , ( "showing", showing |> encodeShowing )
                , ( "card", card |> encodeCard )
                ]

        Answer card ->
            E.object
                [ ( "type", "Answer" |> E.string )
                , ( "card", card |> encodeCard )
                ]

        NoMoreCards ->
            E.null


type alias GameModel =
    { perfect : Set String, good : Set String, bad : Set String, current : Current, countDown : Int }


initialGameStats : GameModel
initialGameStats =
    { perfect = empty, good = empty, bad = empty, current = NoMoreCards, countDown = 0 }


statsLength : GameModel -> Int
statsLength { perfect, good, bad } =
    size perfect + size good + size bad


decodeGameModel : D.Decoder GameModel
decodeGameModel =
    D.succeed GameModel
        |> optional "perfect" (D.map S.fromList <| D.list D.string) initialGameStats.perfect
        |> optional "good" (D.map S.fromList <| D.list D.string) initialGameStats.good
        |> optional "bad" (D.map S.fromList <| D.list D.string) initialGameStats.bad
        |> optional "current" decodeCurrent initialGameStats.current
        |> optional "countDown" D.int initialGameStats.countDown


encodeGameModel : GameModel -> E.Value
encodeGameModel model =
    E.object
        [ ( "perfect", model.perfect |> E.array E.string << A.fromList << S.toList )
        , ( "good", model.good |> E.array E.string << A.fromList << S.toList )
        , ( "bad", model.bad |> E.array E.string << A.fromList << S.toList )
        , ( "current", model.current |> encodeCurrent )
        , ( "countDown", model.countDown |> E.int )
        ]
