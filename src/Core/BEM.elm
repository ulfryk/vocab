module Core.BEM exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (class)
import List exposing (foldl)

type alias BemTools msg = (Attribute msg, String -> Attribute msg, String -> List String -> Attribute msg)

bem : String -> BemTools msg
bem base = (
  class base,
  (\ e -> bemElementClass base e []),
  bemElementClass base)

bemElementClass : String -> String -> List String -> Attribute msg
bemElementClass base name =
    class << foldl (\ e a -> base ++ "__" ++ name ++ "--" ++ e ++ " " ++ a) (base ++ "__" ++ name)

getRootClass : BemTools a -> Attribute a
getRootClass (r, _, _) = r

getElemClassFactory : BemTools a -> String -> Attribute a
getElemClassFactory (_, g, _) = g

getElemModsClassFactory : BemTools a -> String -> List String -> Attribute a
getElemModsClassFactory (_, _, g) = g
