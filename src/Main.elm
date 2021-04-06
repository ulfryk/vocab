module Main exposing (..)

import Browser
import HandleCardHtml exposing (handleCard)
import Html exposing (Html, button, li, p, text, ul)
import Html.Events exposing (onClick)
import Layout exposing (layout)
import List

import Manage exposing (ManageMsg)
import Play exposing (PlayMsg(..))
import Random exposing (Generator)
import Set exposing (insert, union)
import State exposing (Card, Model, Scope(..), Showing(..), getNthCard, getPlayableCards, initial, initialGameStats, rollRandomCardIndex)

type Msg = Play PlayMsg | Manage ManageMsg

playNthCard : Int -> Msg
playNthCard n = Play <| SetNth n

initialModel : () -> (Model, Cmd Msg)
initialModel _ = (initial, Cmd.none)

subscriptions : Model ->  Sub Msg
subscriptions _ = Sub.none

main =
  Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ game, archived } as model) =
  case msg of
    Play m ->
        case m of
            Start -> ( model, Random.generate playNthCard (rollRandomCardIndex model) )
            End -> ({ model | scope = Splash, game = initialGameStats, archived = union archived game.perfect }, Cmd.none)
            Next id ->
                let ml = { model | game = { game | good = insert id game.good } } in
                (ml, Random.generate playNthCard <| rollRandomCardIndex ml)
            Drop id ->
                let ml = { model | game = { game | perfect = insert id game.perfect } } in
                (ml, Random.generate playNthCard <| rollRandomCardIndex ml)
            Fail id ->
                let ml = { model | game = { game | bad = insert id game.bad } } in
                (ml, Random.generate playNthCard <| rollRandomCardIndex ml)
            Show card -> ({ model | scope = Playing Both card }, Cmd.none)
            SetNth n ->
                case (getNthCard n model) of
                    Just card -> ({ model |scope = Playing ASide card }, Cmd.none)
                    Nothing -> ({ model | scope = Done }, Cmd.none)


    Manage m -> (model, Cmd.none)

view : Model -> Html Msg
view model =
    layout model [
      case model.scope of
        Splash -> button [ onClick <| Play Start ] [ text "start"]
        Editing _ -> text "…"
        Playing show card -> Html.map Play <| handleCard show card
        Done -> p [] [ text "done ", button [ onClick <| Play End ] [ text "finish"] ]
  ]
