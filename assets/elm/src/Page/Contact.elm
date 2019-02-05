module Page.Contact exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Browser
import Contact exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed exposing (..)
import Http
import Json.Decode as JD exposing (..)
import Json.Decode.Pipeline exposing (required)
import Skeleton exposing (..)



-- MODEL


type RemoteData e a
    = NotRequested
    | Requesting
    | Failure e
    | Success a


type alias Model =
    { contact : RemoteData String Contact }


init : Int -> ( Model, Cmd Msg )
init id =
    ( initialModel, fetch id "" )


initialModel : Model
initialModel =
    { contact = NotRequested }


fetch : Int -> String -> Cmd Msg
fetch page search =
    Http.get
        { url = "http://localhost:4000/api/v1/contacts/" ++ String.fromInt page
        , expect = Http.expectJson FetchResult Contact.decoder
        }



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "Contacts · Phoenix Framework"
    , header = []
    , warning = Skeleton.NoProblems
    , attrs = []
    , kids =
        [ div []
            [ showContactView model ]
        ]
    }


showContactView : Model -> Html Msg
showContactView model =
    case model.contact of
        Success contact ->
            let
                classes =
                    classList
                        [ ( "person-detail", True )
                        , ( "male", contact.gender == 0 )
                        , ( "female", contact.gender == 1 )
                        ]

                ( _, content ) =
                    contactView contact
            in
            div
                [ id "contacts_show" ]
                [ header []
                    [ h3
                        []
                        [ text "Person detail" ]
                    ]
                , backToHomeLink
                , div
                    [ classes ]
                    [ content ]
                ]

        Requesting ->
            warningMessage
                "fa fa-spin fa-cog fa-2x fa-fw"
                "Fetching contact"
                (text "")

        Failure error ->
            warningMessage
                "fa fa-meh-o fa-stack-2x"
                error
                backToHomeLink

        NotRequested ->
            text ""


contactView : Contact -> ( String, Html msg )
contactView model =
    let
        classes =
            classList
                [ ( "card", True )
                , ( "male", model.gender == 0 )
                , ( "female", model.gender == 1 )
                ]

        fullName =
            model.first_name ++ " " ++ model.last_name
    in
    ( String.fromInt model.id
    , div
        [ classes ]
        [ div
            [ class "inner" ]
            [ header
                []
                [ div
                    [ class "avatar-wrapper" ]
                    [ img
                        [ class "avatar"
                        , src model.picture
                        ]
                        []
                    ]
                , div
                    [ class "info-wrapper" ]
                    [ h4
                        []
                        [ text fullName ]
                    , Html.ul
                        [ class "meta" ]
                        [ li
                            []
                            [ i
                                [ class "fa fa-map-marker" ]
                                []
                            , text model.location
                            ]
                        , li
                            []
                            [ i
                                [ class "fa fa-birthday-cake" ]
                                []
                            , text model.birth_date
                            ]
                        ]
                    ]
                ]
            , div
                [ class "card-body" ]
                [ div
                    [ class "headline" ]
                    [ p [] [ text model.headline ] ]
                , Html.ul
                    [ class "contact-info" ]
                    [ li
                        []
                        [ i
                            [ class "fa fa-phone" ]
                            []
                        , text model.phone_number
                        ]
                    , li
                        []
                        [ i
                            [ class "fa fa-envelope" ]
                            []
                        , text model.email
                        ]
                    ]
                ]
            ]
        ]
    )


backToHomeLink : Html Msg
backToHomeLink =
    a
        [ href "/" ]
        [ text "← Back to contact list" ]



-- UPDATE


type Msg
    = FetchResult (Result Http.Error Contact)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult result ->
            case result of
                Ok response ->
                    ( { model | contact = Success response }, Cmd.none )

                Err error ->
                    ( { model | contact = Failure "Something went wrong..." }, Cmd.none )
