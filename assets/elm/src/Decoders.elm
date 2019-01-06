module Decoders exposing (contactDecoder, contactListDecoder)

import Json.Decode as JD exposing (..)
import Json.Decode.Pipeline exposing (required)
import Model exposing (..)


contactListDecoder : JD.Decoder ContactList
contactListDecoder =
    succeed
        ContactList
        |> required "entries" (list contactDecoder)
        |> required "page_number" int
        |> required "total_entries" int
        |> required "total_pages" int


contactDecoder : JD.Decoder Contact
contactDecoder =
    succeed
        Contact
        |> required "id" int
        |> required "first_name" string
        |> required "last_name" string
        |> required "gender" int
        |> required "birth_date" string
        |> required "location" string
        |> required "phone_number" string
        |> required "email" string
        |> required "headline" string
        |> required "picture" string
