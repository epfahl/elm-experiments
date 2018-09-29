module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes exposing (src)



-- Constants and helpers


backgroundColor =
    rgb255 240 240 240


shortCardTopBackgroundColor =
    rgb255 241 223 74


borderColor =
    rgb255 230 230 230


colorWhite =
    rgb255 255 255 255


explain =
    Element.explain Debug.todo


fontFamily =
    [ Font.typeface "Helvetica"
    , Font.sansSerif
    ]


shortCardWidth =
    250


shortCardAspec =
    0.75


longCardWidth =
    790


longCardAspect =
    12


heightFromAspect width_ aspect_ =
    (width_ / aspect_) |> round |> px


cardShadow =
    { blur = 5
    , color = rgba 0 0 0 0.05
    , offset = ( 0, 2 )
    , size = 1
    }


border =
    { bottom = 0
    , left = 0
    , right = 0
    , top = 0
    }


owlPic width_ =
    el
        [ centerX, centerY ]
        (image [ width (px width_) ]
            { src = "owl.png"
            , description = "This is an Owl."
            }
        )



-- Main


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- Model


type alias Model =
    {}


init : Model
init =
    {}



-- Update


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model



-- View


view : Model -> Html Msg
view model =
    Element.layout
        [ Background.color backgroundColor
        ]
    <|
        column
            [ centerX
            , centerY
            , spacing 20
            ]
            [ row [ spacing 20 ]
                [ viewShortCard model
                , viewShortCard model
                , viewShortCard model
                ]
            , column [ spacing 20 ]
                [ viewLongCard model
                , viewLongCard model
                , viewLongCard model
                ]
            ]


viewShortCard : Model -> Element Msg
viewShortCard model =
    let
        cardTop =
            el
                [ width fill
                , height (fillPortion 3)
                , Background.color shortCardTopBackgroundColor
                , centerX
                , centerY
                ]
            <|
                owlPic 150

        cardBottom =
            el
                [ width fill
                , height (fillPortion 1)
                , Background.color colorWhite
                , centerX
                , centerY
                ]
            <|
                el
                    [ centerX
                    , centerY
                    ]
                <|
                    paragraph [ padding 5 ]
                        [ el
                            [ Font.bold
                            , Font.color (rgb255 150 150 150)
                            , Font.family fontFamily
                            ]
                            (text "This is an owwwwrll.")
                        ]
    in
    column
        [ width (px shortCardWidth)
        , height (heightFromAspect shortCardWidth shortCardAspec)
        , Border.shadow cardShadow
        , Element.mouseOver
            [ Border.shadow { cardShadow | color = rgba 0 0 0 0.1, size = 2 }
            ]
        ]
        [ cardTop
        , cardBottom
        ]


viewLongCard : Model -> Element Msg
viewLongCard model =
    let
        cardLeft =
            el
                [ width (fillPortion 1)
                , height fill
                , Background.color colorWhite
                , centerX
                , centerY
                , Border.widthEach { border | right = 1 }
                , Border.color (rgb255 200 200 200)
                ]
            <|
                owlPic 40

        cardRight =
            el
                [ width (fillPortion 8)
                , height fill
                , Background.color colorWhite
                ]
            <|
                paragraph [ padding 10, centerY ]
                    [ el
                        [ Font.bold
                        , Font.color (rgb255 150 150 150)
                        , Font.family fontFamily
                        , Font.size 16
                        ]
                        (text "This is a smaller owwwwrll.")
                    ]
    in
    row
        [ width (px longCardWidth)
        , height (heightFromAspect longCardWidth longCardAspect)
        , Border.shadow cardShadow
        , Element.mouseOver
            [ Border.shadow { cardShadow | color = rgba 0 0 0 0.1, size = 2 }
            ]
        ]
        [ cardLeft
        , cardRight
        ]
