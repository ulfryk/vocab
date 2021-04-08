module PlayMsg exposing (..)

import Card exposing (Card, cardId)
import List exposing (drop, filter, head, length)
import Random exposing (Generator)
import Set exposing (Set, insert, member, union)
import Task exposing (succeed)

import GameModel exposing (Current(..), GameStats, Showing(..), initialGameStats)

type PlayMsg = Start | Show Card | Fail String | Next String | Drop String | SetNth Int | End | GameEnd (Set String)

isPlayed : GameStats -> Card -> Bool
isPlayed g c =
  case g.current of
      Question _ card -> (cardId c) == (cardId card)
      Answer card -> (cardId c) == (cardId card)
      _ -> False

isArchived : Set String -> Card -> Bool
isArchived archived c = member (cardId c) archived

isOutOfGame : GameStats -> Card -> Bool
isOutOfGame { perfect, good, bad } c =
    let done = union perfect <| union good bad in
    member (cardId c) done

isAvailable : Set String -> GameStats -> Card -> Bool
isAvailable archived game c =
  (not <| isOutOfGame game c) &&
  (not <| isArchived archived c) &&
  (not <| isPlayed game c)

getAvailableCards : Set String -> List Card -> GameStats -> List Card
getAvailableCards archived cards game =
    filter (isAvailable archived game) cards

getNthCard : Set String -> List Card -> Int -> GameStats -> Maybe Card
getNthCard a c n = head << drop n << getAvailableCards a c

rollRandomCardIndex : Set String -> List Card -> GameStats -> Generator Int
rollRandomCardIndex archived cards game = Random.int 0 <| (length <| getAvailableCards archived cards game) - 1

updateGameAndRollNextIndex : Set String -> List Card -> GameStats -> (GameStats, Cmd PlayMsg)
updateGameAndRollNextIndex archived cards game =
    (game, Random.generate SetNth <| rollRandomCardIndex archived cards game)

updateCurrent : GameStats -> Current -> (GameStats, Cmd PlayMsg)
updateCurrent g current = ({ g | current = current }, Cmd.none)

updateOnPlay : PlayMsg -> Set String -> List Card -> GameStats -> (GameStats, Cmd PlayMsg)
updateOnPlay m archived cards game =
        case m of
            Start -> ( game, Random.generate SetNth (rollRandomCardIndex archived cards game) )
            End -> (initialGameStats, Task.perform GameEnd <| succeed (union archived game.perfect) )
            Next id -> updateGameAndRollNextIndex archived cards { game | good = insert id game.good }
            Drop id -> updateGameAndRollNextIndex archived cards { game | perfect = insert id game.perfect }
            Fail id -> updateGameAndRollNextIndex archived cards { game | bad = insert id game.bad }
            Show card -> updateCurrent game <| Answer card
            SetNth n ->
                case (getNthCard archived cards n game) of
                    Just card -> updateCurrent game <| Question ASide card
                    Nothing -> updateCurrent game <| NoMoreCards
            _ -> (game, Cmd.none)
