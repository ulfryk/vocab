module State exposing (..)

import List exposing (drop, filter, head, length)
import Random exposing (Generator)
import Set exposing (Set, empty, member)

type alias CardInput = { aSide: String, bSide: String }
type alias Card = { id: String, aSide: String, bSide: String }
type Showing = ASide | BSide | Both
type Scope = Splash | Editing CardInput | Playing Showing Card | Done
type alias Model = { cards: List Card, hidden: Set String, archived: Set String, scope: Scope, next: Int }

mock = [
  {id = "0000", aSide = "dupa", bSide = "arse"},
  {id = "0010", aSide = "fiut", bSide = "dick"},
  {id = "0100", aSide = "kutasiarz", bSide = "asshole"},
  {id = "0011", aSide = "zjeb", bSide = "cunt"},
  {id = "0101", aSide = "cipka", bSide = "pussy"}]

initial : Model
initial = { cards = mock, hidden = empty, archived = empty, scope = Splash, next = -1 }

getAvailableCards : Model -> List Card
getAvailableCards { cards, hidden, archived, scope } =
    filter ( \c ->  (
        not (member c.id hidden)
    ) && (
        not (member c.id archived)
    ) && (
        case scope of
           Playing _ card -> c.id /= card.id
           _ -> True
    )) cards

getNthCard : Int -> Model -> Maybe Card
getNthCard n = head << drop n << getAvailableCards

rollRandomCardIndex : Model -> Generator Int
rollRandomCardIndex m = Random.int 0 <| (length <| getAvailableCards m) - 1
