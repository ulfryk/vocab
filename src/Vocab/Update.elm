module Vocab.Update exposing (..)

import Core.Cmd exposing (sendMsg)
import Dict
import Set exposing (empty, insert, remove)
import Vocab.Api.ApiClient exposing (apiGetCards, apiGetSheets)
import Vocab.Api.ApiMsg exposing (ApiMsg(..))
import Vocab.Api.DTO.Card exposing (Card, cardId)
import Vocab.Api.DTO.SheetData exposing (SheetData(..))
import Vocab.Game.GameModel exposing (GameModel)
import Vocab.Game.GameMsg exposing (GameMsg(..), updateOnPlay)
import Vocab.Manage.ManageModel exposing (ManageModel, setApiKey, setDataId, toCredentials)
import Vocab.Manage.ManageMsg exposing (ManageMsg(..))
import Vocab.Model exposing (Model, Scope(..), getCards, initial)
import Vocab.Msg exposing (Msg(..))
import Vocab.Splash.SplashMsg exposing (SplashMsg(..))
import Vocab.Sync as Sync


callForData : ManageModel -> Cmd Msg
callForData { apiKey, dataId } =
    case apiKey of
        Just key ->
            case dataId of
                Just id ->
                    Cmd.map Api (apiGetSheets { key = key, id = id })

                Nothing ->
                    Cmd.none

        Nothing ->
            Cmd.none


liftPlayUpdate : Model -> (a -> Msg) -> ( GameModel, Cmd a ) -> ( Model, Cmd Msg )
liftPlayUpdate model mapper ( game, command ) =
    ( { model | game = game }, Cmd.map mapper command )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ game, archived, cards } as model) =
    case msg of
        Play m ->
            case m of
                GameEnd arch ->
                    Sync.sync ( { model | archived = arch, scope = Splash }, Cmd.none )

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
                    Sync.sync ( { model | archived = empty }, Cmd.none )

                SetApiKey key ->
                    ( { model | manage = setApiKey model.manage key }, Cmd.none )

                SetDataId id ->
                    ( { model | manage = setDataId model.manage id }, Cmd.none )

                Reset ->
                    Sync.sync ( initial, Cmd.none )

                Save ->
                    Sync.sync ( { model | scope = Splash }, sendMsg LoadData )

                Done ->
                    Sync.sync ( { model | scope = Splash }, sendMsg LoadData )

        Basic m ->
            case m of
                StartGame count ->
                    liftPlayUpdate { model | scope = Playing } Play <| updateOnPlay Start archived (getCards model) { game | countDown = count }

                StartEditing ->
                    ( { model | scope = Editing }, Cmd.none )

                SelectSheet sheet ->
                    ( { model | sheet = Just sheet }, Cmd.none )

        Loaded sheet newCards ->
            Sync.sync ( { model | loading = False, archived = empty, cards = Dict.insert sheet newCards model.cards }, Cmd.none )

        Errored error ->
            ( { model | loading = False, error = Just error }, Cmd.none )

        Api clientMsg ->
            case clientMsg of
                GotSheets result ->
                    case result of
                        Ok sheets ->
                            ( model
                            , Cmd.batch
                                (List.map
                                    (\s -> Cmd.map Api (apiGetCards (toCredentials model.manage) s))
                                    sheets
                                )
                            )

                        Err error ->
                            ( model, sendMsg <| ApiFailed error )

                GotSheetData result ->
                    case result of
                        Ok data ->
                            case data of
                                SheetData s c ->
                                    ( { model | cards = Dict.insert s c model.cards }, Cmd.none )

                        Err error ->
                            ( model, sendMsg <| ApiFailed error )

        ApiFailed error ->
            ( { model | httpError = Just error }, Cmd.none )

        LoadData ->
            ( model, callForData model.manage )
