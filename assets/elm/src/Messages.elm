module Messages exposing (Msg(..))

import Http
import Model exposing (ContactList)


type Msg
    = FetchResult (Result Http.Error ContactList)
    | Paginate Int
    | HandleSearchInput String
    | HandleFormSubmit
