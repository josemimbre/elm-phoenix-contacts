module Skeleton exposing
    ( Details
    , Segment(..)
    , Warning(..)
    , view
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
        [ Html.map toMsg <|
            div (class "center" :: details.attrs) details.kids
        ]
    }
