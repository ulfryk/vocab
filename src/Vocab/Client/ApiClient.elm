module Vocab.Client.ApiClient exposing (..)

import Http exposing (get)
import Vocab.Client.ClientMsg exposing (ClientMsg, gotSheets)
import Vocab.DTO.SheetsDTO exposing (sheetsDecoder)


apiUrlBase : String
apiUrlBase =
    "https://sheets.googleapis.com/v4/spreadsheets/"


getSheets : String -> String -> Cmd ClientMsg
getSheets id key =
    get
        { url = apiUrlBase ++ id ++ "/?key=" ++ key
        , expect = Http.expectJson gotSheets sheetsDecoder
        }
