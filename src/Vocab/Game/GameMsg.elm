module Vocab.Game.GameMsg exposing (GameMsg(..), updateOnPlay)

import List exposing (drop, filter, head, length)
import Random exposing (Generator)
import Set exposing (Set, insert, member, union)
import Task exposing (succeed)
import Vocab.Api.DTO.Card exposing (Card, cardId)
import Vocab.Game.GameModel exposing (Current(..), GameModel, Showing(..), initialGameStats)


type GameMsg
    = Start
    | Show Card
    | Fail String
    | Next String
    | Drop String
    | SetNth Int
    | End
    | GameEnd (Set String)


isPlayed : GameModel -> Card -> Bool
isPlayed g c =
    case g.current of
        Question _ card ->
            cardId c == cardId card

        Answer card ->
            cardId c == cardId card

        _ ->
            False


isArchived : Set String -> Card -> Bool
isArchived archived c =
    member (cardId c) archived


isOutOfGame : GameModel -> Card -> Bool
isOutOfGame { perfect, good, bad } c =
    let
        done =
            union perfect <| union good bad
    in
    member (cardId c) done


isAvailable : Set String -> GameModel -> Card -> Bool
isAvailable archived game c =
    (not <| isOutOfGame game c)
        && (not <| isArchived archived c)
        && (not <| isPlayed game c)


getAvailableCards : Set String -> List Card -> GameModel -> List Card
getAvailableCards archived cards game =
    filter (isAvailable archived game) cards


getNthCard : Set String -> List Card -> Int -> GameModel -> Maybe Card
getNthCard a c n =
    head << drop n << getAvailableCards a c


rollRandomCardIndex : Set String -> List Card -> GameModel -> Generator Int
rollRandomCardIndex archived cards game =
    Random.int 0 <| (length <| getAvailableCards archived cards game) - 1


updateGameAndRollNextIndex : Set String -> List Card -> GameModel -> ( GameModel, Cmd GameMsg )
updateGameAndRollNextIndex archived cards game =
    ( { game | countDown = game.countDown - 1 }, Random.generate SetNth <| rollRandomCardIndex archived cards game )


updateCurrent : GameModel -> Current -> ( GameModel, Cmd GameMsg )
updateCurrent g current =
    ( { g | current = current }, Cmd.none )


updateOnPlay : GameMsg -> Set String -> List Card -> GameModel -> ( GameModel, Cmd GameMsg )
updateOnPlay m archived cards game =
    case m of
        Start ->
            ( game, Random.generate SetNth (rollRandomCardIndex archived cards game) )

        End ->
            ( initialGameStats, Task.perform GameEnd <| succeed (union archived game.perfect) )

        Next id ->
            updateGameAndRollNextIndex archived cards { game | good = insert id game.good }

        Drop id ->
            updateGameAndRollNextIndex archived cards { game | perfect = insert id game.perfect }

        Fail id ->
            updateGameAndRollNextIndex archived cards { game | bad = insert id game.bad }

        Show card ->
            updateCurrent game <| Answer card

        SetNth n ->
            case getNthCard archived cards n game of
                Just card ->
                    updateCurrent game <| Question ASide card

                Nothing ->
                    updateCurrent game <| NoMoreCards

        _ ->
            ( game, Cmd.none )
