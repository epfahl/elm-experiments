module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Debug
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)



-- Constants and helpers


lightGray : Element.Color
lightGray =
    rgb255 200 200 200


darkGray : Element.Color
darkGray =
    rgb255 60 60 60


white : Element.Color
white =
    rgb255 255 255 255


blue : Element.Color
blue =
    rgb255 5 71 151



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


type alias Model =
    { key : Nav.Key
    , route : Maybe Route
    , login : Form
    }


type alias Form =
    { email : String
    , password : String
    }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { key = navKey
      , route = Parser.parse routeParser url
      , login = Form "" ""
      }
    , Cmd.none
    )



-- View


view : Model -> Browser.Document Msg
view model =
    let
        _ =
            Debug.log "view route: " (routeToString model.route)
    in
    let
        ( title, body ) =
            case model.route of
                Just Home ->
                    ( "Home", viewHome model )

                Just Login ->
                    ( "Login", viewLogin model )

                Nothing ->
                    ( "Invalid route", viewError model )
    in
    { title = title
    , body = [ body ]
    }


viewHome : Model -> Html Msg
viewHome _ =
    layout [] <|
        column
            [ centerX
            , centerY
            , width (px 800)
            , spacing 60
            ]
            [ el [ centerX ] <|
                paragraph
                    [ Font.color darkGray
                    , Font.size 80
                    , Font.bold
                    ]
                    [ text "Welcome." ]
            , Input.button
                [ padding 17
                , centerX
                , Background.color blue
                , Border.rounded 5
                ]
                { onPress = Nothing
                , label =
                    link
                        [ centerX
                        , centerY
                        , Font.color white
                        , Font.size 40
                        ]
                        { url = "/login"
                        , label = text "Get started"
                        }
                }
            ]


viewLogin : Model -> Html Msg
viewLogin { login } =
    let
        attrs =
            [ width fill
            , height (px 50)
            , Border.width 1
            , Border.rounded 5
            , Border.color lightGray
            , Font.color darkGray
            ]

        viewEmailInput =
            Input.email
                attrs
                { onChange = EmailEntry
                , text = login.email
                , placeholder = Just (formPlaceholder "Email")
                , label = Input.labelHidden "Enter email"
                }

        viewPasswordInput =
            Input.currentPassword
                attrs
                { onChange = PasswordEntry
                , text = login.password
                , placeholder = Just (formPlaceholder "Password")
                , label = Input.labelHidden "Enter email"
                , show = False
                }

        viewFormSubmitButton =
            Input.button
                [ padding 17
                , alignRight
                , Background.color blue
                , Border.rounded 5
                ]
                { onPress = Nothing
                , label =
                    el
                        [ centerX
                        , centerY
                        , Font.color white
                        ]
                        (text "Sign in")
                }
    in
    layout
        []
    <|
        column
            [ centerX
            , centerY
            , width (px 500)
            , spacing 20
            ]
            [ viewEmailInput
            , viewPasswordInput
            , viewFormSubmitButton
            ]


formPlaceholder : String -> Input.Placeholder Msg
formPlaceholder placeholder =
    Input.placeholder [] <|
        el [ alignLeft, Font.color (rgb255 200 200 200) ] (text placeholder)


viewError : Model -> Html Msg
viewError _ =
    layout [] <|
        column
            [ centerX
            , centerY
            , width (px 800)
            , spacing 60
            ]
            [ el [ centerX ] <|
                paragraph
                    [ Font.color darkGray
                    , Font.size 80
                    , Font.bold
                    ]
                    [ text "Invalid route!" ]
            ]



-- Update


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | GoToLogin
    | EmailEntry String
    | PasswordEntry String
    | SubmitForm Form


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "update route: " (routeToString model.route)
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model
                | route = Parser.parse routeParser url
              }
            , Cmd.none
            )

        EmailEntry email ->
            updateForm (\form -> { form | email = email }) model

        PasswordEntry password ->
            updateForm (\form -> { form | password = password }) model

        _ ->
            ( model, Cmd.none )


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | login = transform model.login }, Cmd.none )



-- Route


type Route
    = Home
    | Login


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Login (s "login")
        ]


routeToString : Maybe Route -> String
routeToString route =
    case route of
        Just Home ->
            "Home"

        Just Login ->
            "Login"

        Nothing ->
            "Nothing"
