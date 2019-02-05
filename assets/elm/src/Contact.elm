module Contact exposing (Contact, decoder)

import Json.Decode as JD exposing (..)
import Json.Decode.Pipeline exposing (required)


type alias Contact =
    { id : Int
    , first_name : String
    , last_name : String
    , gender : Int
    , birth_date : String
    , location : String
    , phone_number : String
    , email : String
    , headline : String
    , picture : String
    }


decoder : JD.Decoder Contact
decoder =
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
