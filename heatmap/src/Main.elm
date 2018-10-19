module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)



-- Constants and helpers


gray =
    rgb255 120 120 120


teal =
    rgb255 98 173 170


orange =
    rgb255 234 127 103


explain =
    Element.explain Debug.todo


{-| An empty element that receives only styling attributes.
-}
box : List (Attribute Msg) -> Element Msg
box attrs =
    el attrs (el [] Element.none)


props =
    { gridSpacing = 5 }



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
    { dims : Dims }


type alias Dims =
    { nrow : Int, ncol : Int }


init : Model
init =
    { dims = Dims 9 7 }



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
view { dims } =
    let
        space =
            5
    in
    Element.layout [] <|
        el
            [ width (px 600)
            , height (px 400)
            , centerX
            , centerY
            ]
        <|
            column
                [ width fill
                , height fill
                , spacing props.gridSpacing
                ]
            <|
                List.repeat dims.nrow
                    (viewRow <|
                        List.repeat
                            dims.ncol
                        <|
                            viewColorCell teal
                    )


viewRow : List (Element Msg) -> Element Msg
viewRow cells =
    row
        [ width fill
        , height (fillPortion (List.length cells))
        , spacing props.gridSpacing
        ]
    <|
        cells


viewColorCell : Element.Color -> Element Msg
viewColorCell color =
    box
        [ width fill
        , height fill
        , Background.color color
        ]
