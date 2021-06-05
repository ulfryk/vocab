module Core.Cmd exposing (..)

import Task exposing (perform, succeed)


sendMsg : msg -> Cmd msg
sendMsg =
    perform identity << succeed
