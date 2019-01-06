module Update exposing (update)

import Messages exposing (..)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult result ->
            case result of
                Ok response ->
                    ( { model | contactList = response }, Cmd.none )

                Err error ->
                    ( { model | error = Just "Something went wrong..." }, Cmd.none )
