module Core.BEM exposing (..)

import Bem exposing (element, mod, modList)
import Html exposing (Attribute)
import Html.Attributes exposing (class)


type alias BemTools msg =
    { bl : Attribute msg
    , el : String -> Attribute msg
    , elMod : String -> ( String, Bool ) -> Attribute msg
    , elModList : String -> List ( String, Bool ) -> Attribute msg
    , mod : ( String, Bool ) -> Attribute msg
    , modList : List ( String, Bool ) -> Attribute msg
    }


elMod : String -> String -> ( String, Bool ) -> Attribute msg
elMod blck lmnt =
    mod (element blck lmnt)


elModList : String -> String -> List ( String, Bool ) -> Attribute msg
elModList blck lmnt =
    modList (element blck lmnt)


block : String -> BemTools msg
block cls =
    let
        b =
            Bem.block cls
    in
    { bl = class cls
    , el = b.el
    , mod = b.mod
    , modList = b.modList
    , elMod = elMod cls
    , elModList = elModList cls
    }
