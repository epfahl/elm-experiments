module Page.Login exposing (Model, Msg, init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Session exposing (Session)



-- Helpers


lightGray : Element.Color
lightGray =
    rgb255 200 200 200


darkGray : Element.Color
darkGray =
    rgb255 80 80 80


white : Element.Color
white =
    rgb255 255 255 255


blue : Element.Color
blue =
    rgb255 5 71 151


props =
    { borderRound = 5
    , formInputHeight = 50
    , buttonColor = blue
    , elementSpacing = 20
    }


formInputAttrs =
    [ width fill
    , height (px props.formInputHeight)
    , Border.width 1
    , Border.rounded props.borderRound
    , Border.color lightGray
    , Font.color darkGray
    ]



-- Model


type alias Model =
    { session : Session
    , form : Form
    }


type alias Form =
    { email : String
    , password : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , form =
            { email = ""
            , password = ""
            }
      }
    , Cmd.none
    )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    let
        viewValidate =
            paragraph [ width fill ]
                [ text "You've entered: "
                , el [ Font.bold ] (text model.form.email)
                , text " and "
                , el [ Font.bold ] (text model.form.password)
                ]
    in
    { title = "Login"
    , content =
        Element.layout [] <|
            column
                [ centerX
                , centerY
                , width (px 500)
                , spacing props.elementSpacing
                ]
                [ viewForm model.form
                , viewFormSubmitButton model.form
                , viewValidate
                ]
    }


viewForm : Form -> Element Msg
viewForm form =
    column
        [ width fill
        , spacing props.elementSpacing
        ]
        [ viewEmailInput form.email
        , viewPasswordInput form.password
        ]


viewEmailInput : String -> Element Msg
viewEmailInput email =
    Input.email
        formInputAttrs
        { onChange = EmailEntry
        , text = email
        , placeholder = Just (formPlaceholder "Email")
        , label = Input.labelHidden "Enter email"
        }


viewPasswordInput : String -> Element Msg
viewPasswordInput password =
    Input.currentPassword
        formInputAttrs
        { onChange = PasswordEntry
        , text = password
        , placeholder = Just (formPlaceholder "Password")
        , label = Input.labelHidden "Enter email"
        , show = False
        }


formPlaceholder : String -> Input.Placeholder Msg
formPlaceholder placeholder =
    Input.placeholder [] <|
        el [ alignLeft, Font.color lightGray ] (text placeholder)


viewFormSubmitButton : Form -> Element Msg
viewFormSubmitButton form =
    Input.button
        [ padding 17
        , alignRight
        , Background.color props.buttonColor
        , Border.rounded props.borderRound
        ]
        { onPress = Just (SubmitForm form)
        , label = el [ centerX, centerY, Font.color white ] (text "Sign in")
        }



-- Update


type Msg
    = NoOp
    | EmailEntry String
    | PasswordEntry String
    | SubmitForm Form


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailEntry email ->
            updateForm (\form -> { form | email = email }) model

        PasswordEntry password ->
            updateForm (\form -> { form | password = password }) model

        SubmitForm form ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )
