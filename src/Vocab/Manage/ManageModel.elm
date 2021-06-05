module Vocab.Manage.ManageModel exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as E
import Maybe exposing (withDefault)
import Vocab.Api.DTO.Credentials exposing (Credentials)


type alias ManageModel =
    { apiKey : Maybe String, dataId : Maybe String }


initialManageModel : ManageModel
initialManageModel =
    { apiKey = Nothing, dataId = Nothing }


setApiKey : ManageModel -> String -> ManageModel
setApiKey model apiKey =
    { model | apiKey = Just apiKey }


setDataId : ManageModel -> String -> ManageModel
setDataId model dataId =
    { model | dataId = Just dataId }


toCredentials : ManageModel -> Credentials
toCredentials { apiKey, dataId } =
    { id = withDefault "" dataId, key = withDefault "" apiKey }


decodeManageModel : Decoder ManageModel
decodeManageModel =
    D.succeed ManageModel
        |> optional "apiKey" (D.maybe D.string) Nothing
        |> optional "dataId" (D.maybe D.string) Nothing


encodeManageModel : ManageModel -> E.Value
encodeManageModel { apiKey, dataId } =
    E.object
        [ ( "apiKey"
          , case apiKey of
                Just key ->
                    E.string key

                Nothing ->
                    E.null
          )
        , ( "dataId"
          , case dataId of
                Just id ->
                    E.string id

                Nothing ->
                    E.null
          )
        ]
