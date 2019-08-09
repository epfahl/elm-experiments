module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Element
    exposing
        ( Element
        , alignLeft
        , alignRight
        , centerX
        , centerY
        , column
        , el
        , fill
        , fillPortion
        , height
        , padding
        , pointer
        , px
        , rgb255
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input exposing (button)
import Html exposing (Html)
import Svg
import Svg.Attributes as SA



-- Constants


lightGray =
    rgb255 200 230 230


fontFamily =
    [ Font.external
        { name = "Lato"
        , url = "https://fonts.googleapis.com/css?family=Lato"
        }
    , Font.sansSerif
    ]


buttonSize =
    40


buttonColor =
    rgb255 180 150 150


clickerFontSize =
    24


clickerFontColor =
    rgb255 100 100 100


resultFontSize =
    35


resultFontColor =
    rgb255 150 150 150



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
    { clickers : ClickerDict
    , result : Float
    }


type alias ClickerDict =
    Dict String Clicker


type alias Clicker =
    { name : String
    , value : Int
    }


init : Model
init =
    Model initClickers 0


initClickers : Dict String Clicker
initClickers =
    let
        clickers =
            [ Clicker "A" 0
            , Clicker "B" 0
            , Clicker "C" 0
            ]
    in
    clickers
        |> List.map (\c -> ( c.name, c ))
        |> Dict.fromList



-- Update


type Msg
    = Increment String
    | Decrement String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment key ->
            let
                newClickers =
                    updateClickers key (+) model.clickers
            in
            { model
                | clickers = newClickers
                , result = updateResult newClickers
            }

        Decrement key ->
            let
                newClickers =
                    updateClickers key (-) model.clickers
            in
            { model
                | clickers = newClickers
                , result = updateResult newClickers
            }


updateClickers :
    String
    -> (Int -> Int -> Int)
    -> ClickerDict
    -> ClickerDict
updateClickers key op clickers =
    Dict.update
        key
        (Maybe.map (\clk -> { clk | value = op clk.value 1 }))
        clickers


updateResult : ClickerDict -> Float
updateResult clickers =
    clickers
        |> Dict.values
        |> List.map (\r -> r.value)
        |> List.sum
        |> toFloat


view : Model -> Html Msg
view model =
    Element.layout [] <|
        column [ centerX, centerY ]
            [ viewClickerRow model
            ]


viewClickerRow : Model -> Element Msg
viewClickerRow model =
    let
        clickerRowElements =
            model.clickers
                |> Dict.map viewClicker
                |> Dict.values
    in
    row [ padding 50, spacing 20 ] <|
        clickerRowElements
            ++ [ viewResult model.result ]


viewClicker : String -> Clicker -> Element Msg
viewClicker key { name, value } =
    el
        [ Background.color lightGray
        , Border.rounded 10
        , width (px 80)
        , height (px 50)
        , pointer
        ]
    <|
        el
            [ centerY
            , centerX
            , alignRight
            ]
        <|
            viewClickerBody key value


viewClickerBody : String -> Int -> Element Msg
viewClickerBody key value =
    let
        valueDisplay =
            el
                [ width (px 20)
                , height (px 25)

                -- , Background.color (rgb255 180 180 180)
                ]
            <|
                el
                    [ centerX
                    , centerY
                    , alignRight
                    , Font.family fontFamily
                    , Font.color clickerFontColor
                    , Font.size clickerFontSize
                    ]
                    (text (String.fromInt value))

        buttonColumn =
            column
                [-- Background.color (rgb255 200 150 150)
                ]
                [ viewClickerButton (Increment key) (arrowUp buttonSize)
                , viewClickerButton (Decrement key) (arrowDown buttonSize)
                ]
    in
    row
        [ spacing 10
        , padding 0
        ]
        [ valueDisplay
        , buttonColumn
        ]


viewClickerButton : Msg -> Element Msg -> Element Msg
viewClickerButton msg icon =
    button
        [ width (px 25)
        , height (px 25)
        ]
        { onPress = Just msg
        , label = icon
        }


viewResult : Float -> Element Msg
viewResult result =
    el
        [ width (px 100)
        , height (px 50)
        ]
    <|
        el
            [ Font.family fontFamily
            , Font.color resultFontColor
            , Font.size resultFontSize
            , centerX
            , centerY
            ]
            (text (String.fromFloat result))



-- Icons


iconTemplate : Int -> String -> String -> Element Msg
iconTemplate size color path =
    Element.html <|
        Svg.svg [ SA.viewBox "0 0 24 24", SA.height <| String.fromInt size ]
            [ Svg.path
                [ SA.fill color
                , SA.d path
                ]
                []
            ]


arrowDown : Int -> Element Msg
arrowDown size =
    iconTemplate size "#969696" "M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"


arrowUp : Int -> Element Msg
arrowUp size =
    iconTemplate size "#969696" "M7.41 15.41L12 10.83l4.59 4.58L18 14l-6-6-6 6z"
