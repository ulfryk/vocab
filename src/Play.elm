module Play exposing (..)

import Random exposing (Generator)
import Set exposing (insert, union)

import State exposing (Card, GameStats, Model, Scope(..), Showing(..), getNthCard, initialGameStats, rollRandomCardIndex)


type PlayMsg = Start | Show Card | Fail String | Next String | Drop String | SetNth Int | End

updateGameAndRollNextIndex : Model -> GameStats -> (Model, Cmd PlayMsg)
updateGameAndRollNextIndex model game =
    let ml = { model | game = game } in
    (ml, Random.generate SetNth <| rollRandomCardIndex ml)

updateOnPlay : PlayMsg -> Model -> (Model, Cmd PlayMsg)
updateOnPlay m ({ archived, game } as model) =
        case m of
            Start -> ( model, Random.generate SetNth (rollRandomCardIndex model) )
            End -> ({ model | scope = Splash, game = initialGameStats, archived = union archived game.perfect }, Cmd.none)
            Next id -> updateGameAndRollNextIndex model { game | good = insert id game.good }
            Drop id -> updateGameAndRollNextIndex model { game | perfect = insert id game.perfect }
            Fail id -> updateGameAndRollNextIndex model { game | bad = insert id game.bad }
            Show card -> ({ model | scope = Playing Both card }, Cmd.none)
            SetNth n ->
                case (getNthCard n model) of
                    Just card -> ({ model |scope = Playing ASide card }, Cmd.none)
                    Nothing -> ({ model | scope = Done }, Cmd.none)
