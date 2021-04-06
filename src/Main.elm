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
import Set exposing (insert)
import State exposing (Card, Model, Scope(..), Showing(..), getAvailableCards, getNthCard, initial, rollRandomCardIndex)

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
update msg model =
  case msg of
    Play m ->
        case m of
            Start -> ( model, Random.generate playNthCard (rollRandomCardIndex model) )
            End -> ({ model | scope = Splash }, Cmd.none)
            Next id ->
                let ml = { model | hidden = insert id model.hidden } in
                (ml, Random.generate playNthCard <| rollRandomCardIndex ml)
            Drop id ->
                let ml = { model | archived = insert id model.hidden } in
                (ml, Random.generate playNthCard <| rollRandomCardIndex ml)
            Show card -> ({ model | scope = Playing Both card }, Cmd.none)
            SetNth n ->
                case (getNthCard n model) of
                    Just card -> ({ model | next = n, scope = Playing ASide card }, Cmd.none)
                    Nothing -> ({ model | next = n, scope = Done }, Cmd.none)
    Manage m -> (model, Cmd.none)

view : Model -> Html Msg
view model =
    layout model [
      case model.scope of
        Splash -> button [ onClick <| Play Start ] [ text "start"]
        Editing _ -> text "…"
        Playing show card -> Html.map Play <| handleCard show card
        Done -> p [] [ text "congratulations" ]
      ,
      ul [] (List.map (\c -> li [] [ text (c.id ++ ":: " ++ c.aSide ++ " / " ++ c.bSide) ]) (getAvailableCards model))
  ]
