module Skeleton exposing
    ( Details
    , Segment(..)
    , Warning(..)
    , view
    , warningMessage
    )

import Browser exposing (..)
import Elm.Version as V
import Html exposing (..)
import Html.Attributes exposing (..)



-- NODE


type alias Details msg =
    { title : String
    , header : List Segment
    , warning : Warning
    , attrs : List (Attribute msg)
    , kids : List (Html msg)
    }


type Warning
    = NoProblems
    | NewerVersion String V.Version


type Segment
    = Text String
    | Link String String



-- VIEW


view : (a -> msg) -> Details a -> Browser.Document msg
view toMsg details =
    { title =
        details.title
    , body =
        [ main_ [ attribute "role" "main", class "container" ]
            [ section
                []
                [ viewHeader
                , Html.map toMsg <|
                    div (class "center" :: details.attrs) details.kids
                ]
            ]
        ]
    }


viewHeader : Html msg
viewHeader =
    header
        [ class "main-header" ]
        [ h1
            []
            [ text "Phoenix and Elm: A real use case" ]
        ]


warningMessage : String -> String -> Html msg -> Html msg
warningMessage iconClasses message content =
    div
        [ class "warning" ]
        [ span
            [ class "fa-stack" ]
            [ i [ class iconClasses ] [] ]
        , h4
            []
            [ text message ]
        , content
        ]
