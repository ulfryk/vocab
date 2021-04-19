module Vocab.Manage.ManageModel exposing (..)

type alias ManageModel = { apiKey : Maybe String, dataId: Maybe String }

initialManageModel : ManageModel
initialManageModel = { apiKey = Nothing , dataId = Nothing }

setApiKey : ManageModel -> String -> ManageModel
setApiKey model apiKey = { model | apiKey = Just apiKey }

setDataId : ManageModel -> String -> ManageModel
setDataId model dataId = { model | dataId = Just dataId }
