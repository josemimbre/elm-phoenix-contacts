module Main exposing (init, main)

import Browser
import Commands exposing (fetch)
import Html
import Messages exposing (Msg(..))
import Model exposing (..)
import Update exposing (..)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetch 1 "" )


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
