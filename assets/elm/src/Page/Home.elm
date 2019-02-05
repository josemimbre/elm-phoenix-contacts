module Page.Home exposing
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
    { contactList : RemoteData String ContactList
    , search : String
    }


type alias ContactList =
    { entries : List Contact
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetch 1 "" )


initialModel : Model
initialModel =
    { contactList = NotRequested
    , search = ""
    }


fetch : Int -> String -> Cmd Msg
fetch page search =
    Http.get
        { url = "http://localhost:4000/api/v1/contacts?page=" ++ String.fromInt page ++ "&search=" ++ search
        , expect = Http.expectJson FetchResult contactListDecoder
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
            [ indexView model ]
        ]
    }


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        (viewContent model)


viewContent : Model -> List (Html Msg)
viewContent model =
    case model.contactList of
        NotRequested ->
            [ text "" ]

        Requesting ->
            [ searchSection model
            , warningMessage
                "fa fa-spin fa-cog fa-2x fa-fw"
                "Searching for contacts"
                (text "")
            ]

        Failure error ->
            [ warningMessage
                "fa fa-meh-o fa-stack-2x"
                error
                (text "")
            ]

        Success page ->
            [ searchSection model
            , paginationList page
            , div
                []
                [ contactsList model page ]
            , paginationList page
            ]


warningMessage : String -> String -> Html Msg -> Html Msg
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


searchSection : Model -> Html Msg
searchSection model =
    div
        [ class "filter-wrapper" ]
        [ div
            [ class "overview-wrapper" ]
            [ h3
                []
                [ text <| headerText model ]
            ]
        , div
            [ class "form-wrapper" ]
            [ Html.form
                [ onSubmit HandleFormSubmit ]
                [ resetButton model
                    "reset"
                , input
                    [ type_ "search"
                    , placeholder "Search contacts..."
                    , Html.Attributes.value model.search
                    , onInput HandleSearchInput
                    ]
                    []
                ]
            ]
        ]


headerText : Model -> String
headerText model =
    case model.contactList of
        Success page ->
            let
                totalEntries =
                    page.total_entries

                contactWord =
                    if totalEntries == 1 then
                        "contact"

                    else
                        "contacts"
            in
            if totalEntries == 0 then
                ""

            else
                String.fromInt totalEntries ++ " " ++ contactWord ++ " found"

        _ ->
            ""


paginationList : ContactList -> Html Msg
paginationList page =
    List.range 1 page.total_pages
        |> List.map (paginationLink page.page_number)
        |> Html.Keyed.ul [ class "pagination" ]


paginationLink : Int -> Int -> ( String, Html Msg )
paginationLink currentPage page =
    let
        classes =
            classList [ ( "active", currentPage == page ) ]
    in
    ( String.fromInt page
    , li
        []
        [ a
            [ classes, onClick <| Paginate page ]
            []
        ]
    )


contactsList : Model -> ContactList -> Html Msg
contactsList model page =
    if page.total_entries > 0 then
        page.entries
            |> List.map contactView
            |> Html.Keyed.node "div" [ class "cards-wrapper" ]

    else
        warningMessage
            "fa fa-meh-o fa-stack-2x"
            "No contacts found..."
            (resetButton model "btn")


resetButton : Model -> String -> Html Msg
resetButton model className =
    let
        hide =
            String.length model.search < 1

        classes =
            classList
                [ ( className, True )
                , ( "hidden", hide )
                ]
    in
    a
        [ classes
        , onClick ResetSearch
        ]
        [ text "Reset search" ]


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
    , a
        [ href <| "/contacts/" ++ String.fromInt model.id
        , classes
        ]
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



-- UPDATE


type Msg
    = FetchResult (Result Http.Error ContactList)
    | Paginate Int
    | HandleSearchInput String
    | HandleFormSubmit
    | ResetSearch


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult result ->
            case result of
                Ok response ->
                    ( { model | contactList = Success response }, Cmd.none )

                Err error ->
                    ( { model | contactList = Failure "Something went wrong..." }, Cmd.none )

        Paginate pageNumber ->
            ( model, fetch pageNumber model.search )

        HandleSearchInput value ->
            ( { model | search = value }, Cmd.none )

        HandleFormSubmit ->
            ( { model | contactList = Requesting }, fetch 1 model.search )

        ResetSearch ->
            ( { model | search = "" }, fetch 1 "" )


contactListDecoder : JD.Decoder ContactList
contactListDecoder =
    succeed
        ContactList
        |> required "entries" (JD.list Contact.decoder)
        |> required "page_number" int
        |> required "total_entries" int
        |> required "total_pages" int
