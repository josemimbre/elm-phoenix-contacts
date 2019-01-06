module Commands exposing (fetch)

import Decoders exposing (contactListDecoder)
import Http
import Messages exposing (Msg(..))


fetch : Cmd Msg
fetch =
    Http.get
        { url = "http://localhost:4000/api/v1/contacts"
        , expect = Http.expectJson FetchResult contactListDecoder
        }
