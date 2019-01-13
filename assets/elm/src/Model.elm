module Model exposing (Contact, ContactList, Model, RemoteData(..), initialModel)


type RemoteData e a
    = NotRequested
    | Requesting
    | Failure e
    | Success a


type alias Model =
    { contactList : RemoteData String ContactList
    , search : String
    }


type alias ContactList =
    { entries : List Contact
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    }


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


initialModel : Model
initialModel =
    { contactList = NotRequested
    , search = ""
    }
