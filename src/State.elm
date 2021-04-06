module State exposing (..)

import List exposing (drop, filter, head, length)
import Random exposing (Generator)
import Set exposing (Set, empty, member, union)

type alias Card = { aSide: String, bSide: String }

type Showing = ASide | BSide | Both

type Scope = Splash | Editing Card | Playing Showing Card | Done

type alias GameStats = { perfect: Set String, good: Set String, bad: Set String }

type alias Model = { cards: List Card, game: GameStats, archived: Set String, scope: Scope }

mock = [
  { aSide = "dupa", bSide = "arse" },
  { aSide = "fiut", bSide = "dick" },
  { aSide = "kutasiarz", bSide = "asshole" },
  { aSide = "zjeb", bSide = "cunt" },
  { aSide = "cipka", bSide = "pussy" }]

cardId : Card -> String
cardId { aSide, bSide } = aSide ++ ":" ++ bSide

initialGameStats : GameStats
initialGameStats = { perfect = empty, good = empty, bad = empty }

initial : Model
initial = {
   cards = mock,
   game = initialGameStats,
   archived = empty,
   scope = Splash }

isPlayed : Scope -> Card -> Bool
isPlayed scope c =
    case scope of
        Playing _ card -> (cardId c) == (cardId card)
        _ -> False


isArchived : Model -> Card -> Bool
isArchived { archived } c = member (cardId c) archived

isOutOfGame : GameStats -> Card -> Bool
isOutOfGame { perfect, good, bad } c =
    let done = union perfect <| union good bad in
    member (cardId c) done

isAvailable : Model -> Card -> Bool
isAvailable ({ game, scope } as model) c =
  (not <| isOutOfGame game c) &&
  (not <| isArchived model c) &&
  (not <| isPlayed scope c)

getAvailableCards : Model -> List Card
getAvailableCards ({ cards } as model) =
    filter (isAvailable model) cards

getPlayableCards : Model -> List Card
getPlayableCards ({ cards } as model) =
    filter (not << isArchived model) cards

getNthCard : Int -> Model -> Maybe Card
getNthCard n = head << drop n << getAvailableCards

rollRandomCardIndex : Model -> Generator Int
rollRandomCardIndex m = Random.int 0 <| (length <| getAvailableCards m) - 1
