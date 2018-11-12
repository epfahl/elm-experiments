module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)



-- Constants and helpers


teal =
    rgb255 98 173 170


orange =
    rgb255 234 127 103


darkGray =
    rgb255 100 100 100


mediumGray =
    rgb255 130 130 130


lightGray =
    rgb255 200 200 200


explain =
    Element.explain Debug.todo


fontFamily =
    [ Font.external
        { name = "Lato"
        , url = "https://fonts.googleapis.com/css?family=Lato"
        }
    , Font.sansSerif
    ]


labelFontAttrs =
    [ Font.family fontFamily
    , Font.color darkGray
    , Font.semiBold
    , Font.size 16
    ]


{-| An empty block element that receives only styling attributes.
-}
block : List (Attribute Msg) -> Element Msg
block attrs =
    el attrs (el [] Element.none)


corners =
    { topLeft = 0
    , topRight = 0
    , bottomLeft = 0
    , bottomRight = 0
    }


edges =
    { top = 0
    , bottom = 0
    , right = 0
    , left = 0
    }


props =
    { cellHeight = 70
    , fillPortions = { label = 1, bar = 3 }
    , barHeightPercent = 30
    , plotWidth = 650
    , newFills = { label = 1, data = 4 }
    , sepAttrs =
        [ width (px 1)
        , height fill
        , centerX
        , centerY
        , Background.color lightGray
        ]
    }


fillPercent : Float -> (Float -> Length)
fillPercent percent =
    px << (floor << (*) (percent / 100))


dataInit =
    [ { label = "Category 1", value = 20 }
    , { label = "Category 2", value = 22 }
    , { label = "Category 3", value = 23 }
    , { label = "Category 4", value = 18 }
    , { label = "Category 5", value = 21 }
    , { label = "Category 6", value = 19 }
    , { label = "Category 7", value = 20 }
    , { label = "Category 8", value = 21 }
    , { label = "Category 9", value = 18 }
    ]



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
    { data : List Record
    , reference : Float
    , relMax : Float
    }


type alias Record =
    { label : String
    , value : Float
    }


init : Model
init =
    { data = dataInit
    , reference = 19
    , relMax = 4
    }



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
    let
        relativeValues =
            List.map (\{ value } -> value - model.reference) model.data
    in
    Element.layout [] <|
        column
            [ centerX
            , centerY
            , width (px props.plotWidth)
            ]
        <|
            (List.map2 viewRow model.data relativeValues
                ++ [ viewFooterLabel model.reference ]
            )



-- Further generalize with a layout template that allows cells to be filled


viewRow : Record -> Float -> Element Msg
viewRow { label, value } rel =
    let
        labelElement =
            el
                [ width (fillPortion props.newFills.label)
                , height fill
                ]
            <|
                el
                    ([ centerY
                     , alignRight
                     ]
                        ++ labelFontAttrs
                    )
                    (text label)

        barWidth =
            relToWidth rel

        barHeight =
            fillPercent props.barHeightPercent 100

        -- Move defaults to props record
        barAnn padding color =
            el
                [ centerX
                , centerY
                , paddingEach padding
                , Font.size 17
                , Font.color color
                , Background.color (rgb255 255 255 255)
                ]
                (text (valueToString value))

        dataElement orient annPadding barColor =
            block
                [ width (fillPortion props.newFills.data)
                , height fill
                , Element.inFront <|
                    block
                        (props.sepAttrs
                            ++ [ orient <|
                                    block
                                        [ width (px barWidth)
                                        , height barHeight
                                        , Background.color barColor
                                        , centerY
                                        , alignRight
                                        , orient <|
                                            barAnn annPadding barColor
                                        ]
                               ]
                        )
                ]

        ( o, p, c ) =
            if rel < 0 then
                ( Element.onLeft, { edges | right = 5 }, orange )

            else if rel > 0 then
                ( Element.onRight, { edges | left = 5 }, teal )

            else
                ( Element.inFront, { edges | top = 10, bottom = 10 }, mediumGray )
    in
    row
        [ width fill
        , height (px props.cellHeight)
        , spacing 10
        ]
        [ labelElement
        , dataElement o p c
        ]


viewFooterLabel : Float -> Element Msg
viewFooterLabel ref =
    row
        [ width fill
        , height (px (floor (0.25 * props.cellHeight)))
        , spacing 10
        ]
        [ block
            [ width (fillPortion props.newFills.label)
            , height fill
            ]
        , block
            [ width (fillPortion props.newFills.data)
            , height fill
            , Element.inFront <|
                block
                    (props.sepAttrs
                        ++ [ Element.below <|
                                el
                                    [ centerX
                                    , centerY
                                    , Font.size 20
                                    , Font.color darkGray
                                    , Font.semiBold
                                    , paddingEach { edges | top = 10 }
                                    ]
                                    (text (valueToString ref))
                           ]
                    )
            ]
        ]


relToWidth : Float -> Int
relToWidth rel =
    let
        -- prop to accommodate bar label
        maxFrac =
            0.8

        -- from model
        relMax =
            4

        frac =
            maxFrac * abs rel / relMax
    in
    floor (props.plotWidth * ((0.5 * props.newFills.data) / (props.newFills.label + props.newFills.data)) * frac)


valueToString : Float -> String
valueToString value =
    String.fromFloat value ++ "%"



{-
   ToDo:
   - add tooltip UI (inFront on mouseOver?)
-}
