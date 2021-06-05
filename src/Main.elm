module Main exposing (..)

import Browser
import Vocab.Init as Init
import Vocab.Sync as Sync
import Vocab.Update as Update
import Vocab.View as View


main =
    Browser.element
        { init = Init.init
        , update = \m -> Sync.sync << Update.update m
        , view = View.view
        , subscriptions = \_ -> Sub.none
        }
