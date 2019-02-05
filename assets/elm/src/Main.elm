module Main exposing (main)

import Browser exposing (..)
import Browser.Navigation as Nav
import Html exposing (..)
import Http
import Page.Contact as Contact exposing (..)
import Page.Home as Home exposing (..)
import Page.Problem as Problem exposing (..)
import Skeleton exposing (..)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, custom, int, map, oneOf, s, string, top)



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | Home Home.Model
    | Contact Contact.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    stepUrl url
        { key = key
        , page = NotFound
        }



-- UPDATE


type Msg
    = HomeMsg Home.Msg
    | ContactMsg Contact.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        HomeMsg msg ->
            case model.page of
                Home home ->
                    Home.update msg home
                        |> updateWith Home HomeMsg model

                _ ->
                    ( model, Cmd.none )

        ContactMsg msg ->
            case model.page of
                Contact contact ->
                    Contact.update msg contact
                        |> updateWith Contact ContactMsg model

                _ ->
                    ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Cmd.none
                    )

        UrlChanged url ->
            stepUrl url model


stepHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
stepHome model ( home, cmds ) =
    ( { model | page = Home home }
    , Cmd.map HomeMsg cmds
    )


stepContact : Model -> ( Contact.Model, Cmd Contact.Msg ) -> ( Model, Cmd Msg )
stepContact model ( contact, cmds ) =
    ( { model | page = Contact contact }
    , Cmd.map ContactMsg cmds
    )



-- VIEW


view : Model -> Document Msg
view model =
    case model.page of
        NotFound ->
            Skeleton.view never
                { title = "Not Found"
                , header = []
                , warning = Skeleton.NoProblems
                , attrs = Problem.styles
                , kids = Problem.notFound
                }

        Home home ->
            Skeleton.view HomeMsg (Home.view home)

        Contact contact ->
            Skeleton.view ContactMsg (Contact.view contact)



-- ROUTER


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        parser =
            oneOf
                [ route top (stepHome model Home.init)
                , route (s "contacts" </> contact_)
                    (\contact ->
                        stepContact model (Contact.init contact)
                    )
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }
            , Cmd.none
            )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser


updateWith : (subModel -> Page) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( { model | page = toModel subModel }, Cmd.map toMsg subCmd )


contact_ : Parser (Int -> a) a
contact_ =
    custom "CONTACT" String.toInt



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
