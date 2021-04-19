port module Main exposing (..)

import Browser
import Html exposing (Html)
import Json.Decode as Decode exposing (Error)
import Json.Encode as Encode
import Set exposing (empty, insert, remove)

import Vocab.DTO.Card exposing (Card, cardDecoder, cardId)
import Vocab.DTO.Creds exposing (Creds, encodeCreds)
import Vocab.DTO.DataSnapshot exposing (DataSnapshot, dataSnapshotDecoder, encodeDataSnapshot)
import Vocab.Base.SplashMsg exposing (SplashMsg(..))
import Vocab.Base.SplashHtml exposing (splashView)
import Vocab.Game.GameModel exposing (GameStats)
import Vocab.Game.PlayMsg exposing (PlayMsg(..), updateOnPlay)
import Vocab.Game.GameViewHtml exposing (gameView)
import Vocab.Manage.ManageModel exposing (setApiKey, setDataId)
import Vocab.Manage.ManageViewHtml exposing (manageView)
import Vocab.Manage.ManageMsg exposing (ManageMsg(..))
import Vocab.State exposing (Model, Scope(..), initial)
import Vocab.Layout exposing (layout)


type Msg = Play PlayMsg | Manage ManageMsg | Basic SplashMsg | Loaded (List Card) | Errored Error

port syncData : Encode.Value -> Cmd msg
port loadExternalData : Encode.Value -> Cmd msg
port loadedExternalData : (Decode.Value -> msg) -> Sub msg

initialModel : Decode.Value -> (Model, Cmd Msg)
initialModel flags =
    let data = Decode.decodeValue dataSnapshotDecoder flags in
    case data of
        Ok value -> ({ initial | cards = value.cards, archived = value.archived }, Cmd.none)
        Err err -> ({ initial | error = Just err }, Cmd.none)

subscriptions : Model ->  Sub Msg
subscriptions _ =
  let fromJson = Decode.decodeValue (Decode.list cardDecoder) in
  loadedExternalData (\val ->
    case fromJson val of
        Ok data -> Loaded data
        Err err -> Errored err
  )


liftPlayUpdate : Model -> (a -> Msg) -> (GameStats, Cmd a) -> (Model, Cmd Msg)
liftPlayUpdate model mapper (game, command) = ({ model | game = game}, Cmd.map mapper command)

main =
  Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }

updateAndSync : Model -> (Model, Cmd Msg)
updateAndSync ({ cards, archived } as model) = (model, syncData <| encodeDataSnapshot { cards = cards, archived = archived })

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ game, archived, cards } as model) =
  case msg of
    Play m -> case m of
        GameEnd arch -> updateAndSync { model | archived = arch, scope = Splash }
        _ -> liftPlayUpdate model Play <| updateOnPlay m archived cards game
    Manage m -> case m of
        Done -> updateAndSync { model | scope = Splash }
        ToggleArchived toggle card -> case toggle of
            True -> ({ model | archived = insert (cardId card) archived }, Cmd.none)
            False -> ({ model | archived = remove (cardId card) archived }, Cmd.none)
        LoadExternalData -> ({ model | loading = True }, loadExternalData <| encodeCreds model.manage )
        UnArchiveAll -> updateAndSync { model | archived = empty }
        SetApiKey key -> ({ model | manage = setApiKey model.manage key }, Cmd.none)
        SetDataId id -> ({ model | manage = setDataId model.manage id  }, Cmd.none)
    Basic m -> case m of
        StartGame -> liftPlayUpdate { model | scope = Playing } Play <| updateOnPlay Start archived cards game
        StartEditing -> ({ model | scope = Editing }, Cmd.none)
    Loaded data -> updateAndSync { model | loading = False , archived = empty, cards = data }
    Errored error ->  ({ model | loading = False , error = Just error }, Cmd.none )




view : Model -> Html Msg
view model =
    layout model [
      case model.scope of
        Splash -> Html.map Basic <| splashView ()
        Playing -> Html.map Play <| gameView model.game
        Editing -> Html.map Manage <| manageView model.archived model.cards model.manage
  ]
