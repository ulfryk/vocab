port module Main exposing (..)

import Browser
import Dict exposing (keys)
import Html exposing (Html)
import Json.Decode as Decode exposing (Error)
import Json.Encode as Encode
import Set exposing (empty, insert, remove)
import Vocab.Base.SplashHtml exposing (splashView)
import Vocab.Base.SplashMsg exposing (SplashMsg(..))
import Vocab.DTO.Card exposing (Card, cardId)
import Vocab.DTO.DataSnapshot exposing (DataSnapshot, dataSnapshotDecoder, encodeDataSnapshot)
import Vocab.Game.GameModel exposing (GameStats)
import Vocab.Game.GameViewHtml exposing (gameView)
import Vocab.Game.PlayMsg exposing (PlayMsg(..), updateOnPlay)
import Vocab.Layout exposing (layout)
import Vocab.Manage.ManageModel exposing (setApiKey, setDataId)
import Vocab.Manage.ManageMsg exposing (ManageMsg(..))
import Vocab.Manage.ManageViewHtml exposing (manageView)
import Vocab.State exposing (Model, Scope(..), getCards, initial)


type Msg
    = Play PlayMsg
    | Manage ManageMsg
    | Basic SplashMsg
    | Loaded String (List Card)
    | Errored Error


port syncData : Encode.Value -> Cmd msg


port resetAll : () -> Cmd msg


initialModel : Decode.Value -> ( Model, Cmd Msg )
initialModel flags =
    let
        data =
            Decode.decodeValue dataSnapshotDecoder flags
    in
    case data of
        Ok value ->
            ( { initial | archived = value.archived, manage = value.creds }, Cmd.none )

        Err err ->
            ( { initial | error = Just err }, Cmd.none )


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none


liftPlayUpdate : Model -> (a -> Msg) -> ( GameStats, Cmd a ) -> ( Model, Cmd Msg )
liftPlayUpdate model mapper ( game, command ) =
    ( { model | game = game }, Cmd.map mapper command )


main =
    Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }


updateAndSync : Model -> ( Model, Cmd Msg )
updateAndSync ({ cards, archived, manage } as model) =
    ( model, syncData <| encodeDataSnapshot { archived = archived, creds = manage } )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ game, archived, cards } as model) =
    case msg of
        Play m ->
            case m of
                GameEnd arch ->
                    updateAndSync { model | archived = arch, scope = Splash }

                _ ->
                    liftPlayUpdate model Play <| updateOnPlay m archived (getCards model) game

        Manage m ->
            case m of
                ToggleArchived toggle card ->
                    case toggle of
                        True ->
                            ( { model | archived = insert (cardId card) archived }, Cmd.none )

                        False ->
                            ( { model | archived = remove (cardId card) archived }, Cmd.none )

                UnArchiveAll ->
                    updateAndSync { model | archived = empty }

                SetApiKey key ->
                    ( { model | manage = setApiKey model.manage key }, Cmd.none )

                SetDataId id ->
                    ( { model | manage = setDataId model.manage id }, Cmd.none )

                Reset ->
                    ( initial, resetAll () )

                _ ->
                    updateAndSync { model | scope = Splash }

        Basic m ->
            case m of
                StartGame count ->
                    liftPlayUpdate { model | scope = Playing } Play <| updateOnPlay Start archived (getCards model) { game | countDown = count }

                StartEditing ->
                    ( { model | scope = Editing }, Cmd.none )

                SelectSheet sheet ->
                    ( { model | sheet = Just sheet }, Cmd.none )

        Loaded sheet newCards ->
            updateAndSync { model | loading = False, archived = empty, cards = Dict.insert sheet newCards model.cards }

        Errored error ->
            ( { model | loading = False, error = Just error }, Cmd.none )


view : Model -> Html Msg
view model =
    layout model
        [ case model.scope of
            Splash ->
                Html.map Basic <| splashView (keys model.cards) (getCards model) model.sheet

            Playing ->
                Html.map Play <| gameView model.game

            Editing ->
                Html.map Manage <| manageView model.archived (getCards model) model.manage
        ]
