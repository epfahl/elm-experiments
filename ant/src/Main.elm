module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Svg exposing (Svg, g, rect, svg)
import Svg.Attributes
    exposing
        ( fill
        , height
        , stroke
        , viewBox
        , width
        , x
        , y
        )
import Time
import Tuple


cellWidth : Int
cellWidth =
    20


stepTime : Float
stepTime =
    10


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { board : Board
    , ant : Ant
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model initBoard initAnt, Cmd.none )


initBoard : Board
initBoard =
    Dict.empty


initAnt : Ant
initAnt =
    Ant ( 0, 0 ) Right


type Dir
    = Up
    | Down
    | Left
    | Right


type Color
    = Black
    | White


type alias Pos =
    ( Int, Int )


type alias Cell =
    { pos : Pos
    , color : Color
    }


type alias Ant =
    { pos : Pos
    , dir : Dir
    }


type alias Board =
    Dict Pos Cell



-- UPDATE


type Msg
    = Step Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Step _ ->
            ( updateOnStep model, Cmd.none )


updateOnStep : Model -> Model
updateOnStep { ant, board } =
    let
        antCell =
            getAntCell ant.pos board

        newAntCell =
            { antCell | color = flipCellColor antCell.color }

        newBoard =
            Dict.insert ant.pos newAntCell board

        newAnt =
            updateAnt ant antCell
    in
    Model newBoard newAnt


getAntCell : Pos -> Board -> Cell
getAntCell antPos board =
    Dict.get antPos board
        |> Maybe.withDefault (Cell antPos White)


flipCellColor : Color -> Color
flipCellColor color =
    case color of
        Black ->
            White

        White ->
            Black


updateAnt : Ant -> Cell -> Ant
updateAnt ant cell =
    let
        newDir =
            updateAntDir ant cell
    in
    { ant | dir = newDir, pos = updateAntPos newDir ant.pos }


updateAntDir : Ant -> Cell -> Dir
updateAntDir { dir } { color } =
    case color of
        White ->
            turnRight dir

        Black ->
            turnLeft dir



-- Are these turn directions correct?


turnRight : Dir -> Dir
turnRight dir =
    case dir of
        Up ->
            Right

        Right ->
            Down

        Down ->
            Left

        Left ->
            Up


turnLeft : Dir -> Dir
turnLeft dir =
    case dir of
        Up ->
            Left

        Left ->
            Down

        Down ->
            Right

        Right ->
            Up


updateAntPos : Dir -> Pos -> Pos
updateAntPos dir pos =
    case dir of
        Up ->
            Tuple.mapSecond (\x -> x + 1) pos

        Right ->
            Tuple.mapFirst (\x -> x + 1) pos

        Down ->
            Tuple.mapSecond (\x -> x - 1) pos

        Left ->
            Tuple.mapFirst (\x -> x - 1) pos



-- VIEW


view : Model -> Html Msg
view { board, ant } =
    svg [ width "1200", height "800", viewBox "-500 -500 1000 1000" ]
        [ renderCells board
        , renderAnt ant
        ]


renderCells : Board -> Svg Msg
renderCells board =
    g [] (Dict.values board |> List.map renderCell)


renderAnt : Ant -> Svg Msg
renderAnt { pos, dir } =
    renderItem pos (colorForAnt dir)


renderCell : Cell -> Svg Msg
renderCell { pos, color } =
    renderItem pos (colorToSvgFill color)


renderItem : Pos -> String -> Svg Msg
renderItem ( xPos, yPos ) colour =
    let
        halfCellWidth =
            cellWidth // 2
    in
    rect
        [ stroke "black"
        , fill colour
        , x (String.fromInt (xPos * cellWidth - halfCellWidth))
        , y (String.fromInt (yPos * cellWidth - halfCellWidth))
        , width (String.fromInt cellWidth)
        , height (String.fromInt cellWidth)
        ]
        []


colorToSvgFill : Color -> String
colorToSvgFill color =
    case color of
        White ->
            "white"

        Black ->
            "black"


colorForAnt : Dir -> String
colorForAnt dir =
    case dir of
        Right ->
            "red"

        Left ->
            "blue"

        Down ->
            "purple"

        Up ->
            "pink"



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every stepTime Step



-- Update to include random step direction.
