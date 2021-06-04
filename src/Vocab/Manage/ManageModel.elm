module Vocab.Manage.ManageModel exposing (..)

import Maybe exposing (withDefault)
import Vocab.Client.Credentials exposing (Credentials)


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
