module Commands exposing (fetch)

import Decoders exposing (contactListDecoder)
import Http
import Messages exposing (Msg(..))


fetch : Int -> String -> Cmd Msg
fetch page search =
    Http.get
        { url = "http://localhost:4000/api/v1/contacts?page=" ++ String.fromInt page ++ "&search=" ++ search
        , expect = Http.expectJson FetchResult contactListDecoder
        }
