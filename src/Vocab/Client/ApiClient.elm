module Vocab.Client.ApiClient exposing (..)

import Http exposing (get)
import Vocab.Client.ClientMsg exposing (ClientMsg, gotSheetData, gotSheets)
import Vocab.Client.Credentials exposing (Credentials)
import Vocab.DTO.CardsDTO exposing (cardsDecoder)
import Vocab.DTO.SheetsDTO exposing (sheetsDecoder)


apiUrlBase : String
apiUrlBase =
    "https://sheets.googleapis.com/v4/spreadsheets/"



-- GET https://sheets.googleapis.com/v4/spreadsheets/{id}/?key={key}


apiGetSheets : Credentials -> Cmd ClientMsg
apiGetSheets { id, key } =
    get
        { url = apiUrlBase ++ id ++ "/?key=" ++ key
        , expect = Http.expectJson gotSheets sheetsDecoder
        }



-- GET https://sheets.googleapis.com/v4/spreadsheets/{id}/values/{sheet}!A:D?key={key}


apiGetCards : Credentials -> String -> Cmd ClientMsg
apiGetCards { id, key } sheet =
    get
        { url = apiUrlBase ++ id ++ "/values/" ++ sheet ++ "!A:D?key=" ++ key
        , expect = Http.expectJson (gotSheetData sheet) cardsDecoder
        }
