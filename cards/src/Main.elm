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
    rgb255 250 250 250


colCardTopBackgroundColor =
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


colCardWidth =
    250


colCardAspec =
    0.75



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
            ]
            [ row [ spacing 20 ]
                [ viewTableCard model
                , viewTableCard model
                , viewTableCard model
                ]
            ]


viewTableCard : Model -> Element Msg
viewTableCard model =
    let
        cardTop =
            el
                [ width fill
                , height (fillPortion 3)
                , Background.color colCardTopBackgroundColor
                , centerX
                , centerY
                ]
            <|
                el
                    [ centerX, centerY ]
                    (image [ width (px 150) ]
                        { src = "owl.png"
                        , description = "This is an Owl."
                        }
                    )

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
        [ width (px colCardWidth)
        , height (px (round (colCardWidth / colCardAspec)))
        , Border.shadow
            { blur = 5
            , color = rgba 0 0 0 0.05
            , offset = ( 0, 2 )
            , size = 1
            }
        , Element.mouseOver
            [ Border.shadow
                { blur = 5
                , color = rgba 0 0 0 0.1
                , offset = ( 0, 2 )
                , size = 2
                }
            ]
        ]
        [ cardTop
        , cardBottom
        ]
