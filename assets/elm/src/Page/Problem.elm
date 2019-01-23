module Page.Problem exposing
    ( notFound
    , offline
    , styles
    )

import Browser.Navigation as Nav
import Elm.Version as V
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Skeleton exposing (..)



-- NOT FOUND


notFound : List (Html msg)
notFound =
    [ Skeleton.warningMessage
        "fa fa-meh-o fa-stack-2x"
        "Page not found"
        backToHomeLink
    ]


backToHomeLink : Html msg
backToHomeLink =
    a
        [ href "/" ]
        [ text "← Back to Home" ]


styles : List (Attribute msg)
styles =
    [ style "text-align" "center"
    , style "color" "#9A9A9A"
    , style "padding" "6em 0"
    ]



-- OFFLINE


offline : String -> List (Html msg)
offline file =
    [ div [ style "font-size" "3em" ]
        [ text "Cannot find "
        , code [] [ text file ]
        ]
    , p [] [ text "Are you offline or something?" ]
    ]
