module Vocab.Api.ApiClient exposing (..)

import Http exposing (get)
import Vocab.Api.DTO.CardsDTO exposing (cardsDecoder)
import Vocab.Api.DTO.Credentials exposing (Credentials)
import Vocab.Api.DTO.SheetsDTO exposing (sheetsDecoder)
import Vocab.Api.ApiMsg exposing (ApiMsg, gotSheetData, gotSheets)


apiUrlBase : String
apiUrlBase =
    "https://sheets.googleapis.com/v4/spreadsheets/"



-- GET https://sheets.googleapis.com/v4/spreadsheets/{id}/?key={key}


apiGetSheets : Credentials -> Cmd ApiMsg
apiGetSheets { id, key } =
    get
        { url = apiUrlBase ++ id ++ "/?key=" ++ key
        , expect = Http.expectJson gotSheets sheetsDecoder
        }



-- GET https://sheets.googleapis.com/v4/spreadsheets/{id}/values/{sheet}!A:D?key={key}


apiGetCards : Credentials -> String -> Cmd ApiMsg
apiGetCards { id, key } sheet =
    get
        { url = apiUrlBase ++ id ++ "/values/" ++ sheet ++ "!A:D?key=" ++ key
        , expect = Http.expectJson (gotSheetData sheet) cardsDecoder
        }
