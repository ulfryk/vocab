module Main exposing (..)

import Browser
import Vocab.Init as Init
import Vocab.Update as Update
import Vocab.View as View


main =
    Browser.element
        { init = Init.init
        , update = Update.update
        , view = View.view
        , subscriptions = \_ -> Sub.none
        }
