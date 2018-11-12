module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Page.Error as Error
import Page.Home as Home
import Page.Login as Login
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



-- Constants and helpers
-- Main


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- Model


type Model
    = NotFound Session
    | Home Home.Model
    | Login Login.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    toModelCmd (Route.fromUrl url)
        (Home { session = Session.fromUser navKey Nothing })



-- View


view : Model -> Browser.Document Msg
view model =
    let
        viewHelper toMsg { title, content } =
            { title = title
            , body = [ Html.map toMsg content ]
            }
    in
    case model of
        NotFound _ ->
            viewHelper (\_ -> Ignored) Error.view

        Home homeModel ->
            viewHelper HomeMsg (Home.view homeModel)

        Login loginModel ->
            viewHelper LoginMsg (Login.view loginModel)



-- Update


type Msg
    = Ignored
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | HomeMsg Home.Msg
    | LoginMsg Login.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )

                Browser.External _ ->
                    ( model, Cmd.none )

        ( UrlChanged url, _ ) ->
            toModelCmd (Route.fromUrl url) model

        ( HomeMsg homeMsg, Home homeModel ) ->
            Home.update homeMsg homeModel
                |> toModelCmdHelper Home HomeMsg model

        ( LoginMsg loginMsg, Login loginModel ) ->
            Login.update loginMsg loginModel
                |> toModelCmdHelper Login LoginMsg model

        ( _, _ ) ->
            ( model, Cmd.none )


toSession : Model -> Session
toSession model =
    case model of
        NotFound session ->
            session

        Home homeModel ->
            homeModel.session

        Login loginModel ->
            loginModel.session


toModelCmd : Maybe Route -> Model -> ( Model, Cmd Msg )
toModelCmd maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Home ->
            Home.init session
                |> toModelCmdHelper Home HomeMsg model

        Just Route.Login ->
            Login.init session
                |> toModelCmdHelper Login LoginMsg model


toModelCmdHelper :
    (subModel -> Model)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg )
    -> ( Model, Cmd Msg )
toModelCmdHelper toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )
