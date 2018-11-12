module Page.Home exposing (Model, Msg, init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Route exposing (Route)
import Session exposing (Session)


darkGray : Element.Color
darkGray =
    rgb255 50 50 50


white : Element.Color
white =
    rgb255 255 255 255


blue : Element.Color
blue =
    rgb255 5 71 151


props =
    { borderRound = 5
    , buttonColor = blue
    }



-- Model


type alias Model =
    { session : Session }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      }
    , Cmd.none
    )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        layout [] <|
            column
                [ centerX
                , centerY
                , width (px 800)
                , spacing 60
                ]
                [ viewWelcome
                , viewSigninButton
                ]
    }


viewWelcome : Element Msg
viewWelcome =
    el [ centerX ] <|
        paragraph
            [ Font.color darkGray
            , Font.size 80
            , Font.bold
            ]
            [ text "Welcome." ]


viewSigninButton : Element Msg
viewSigninButton =
    Input.button
        [ --width (px props.buttonWidth)
          --height (px props.buttonHeight)
          padding 17
        , centerX
        , Background.color props.buttonColor
        , Border.rounded props.borderRound
        ]
        { onPress = Just SignIn
        , label = el [ centerX, centerY, Font.color white, Font.size 30 ] (text "Get started!")
        }



-- Update


type Msg
    = SignIn


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SignIn ->
            ( model, Route.replaceUrl (Session.navKey model.session) Route.Login )
