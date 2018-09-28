module Sidebar exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Html exposing (Html)



-- Colors


colorBackground =
    rgb255 83 57 81


colorSelected =
    rgb255 91 148 138


colorMouseOver =
    rgb255 55 44 55


colorFontSelected =
    rgba255 220 220 220 0.9


colorFontNormal =
    rgba255 180 180 180 0.9


fontFamily =
    [ Font.external
        { name = "Lato"
        , url = "https://fonts.googleapis.com/css?family=Lato"
        }
    , Font.sansSerif
    ]



-- Name list


namesList : List String
namesList =
    [ "general"
    , "random"
    , "problematic"
    , "ludicrous"
    , "insane"
    , "psychopathic"
    , "murderous"
    , "gates-of-hell"
    , "satanic-minion"
    , "demonic-lackey"
    ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Item =
    { id : Int
    , name : String
    , selected : Bool
    }


type alias Model =
    { maxCount : Int
    , items : List Item
    }


init : Model
init =
    let
        items =
            initItems namesList
    in
    { maxCount = List.length items
    , items = items
    }


initItems : List String -> List Item
initItems names =
    let
        hydrate i name =
            Item i ("#  " ++ name) False
    in
    List.map2 hydrate (List.range 1 (List.length names)) names



-- UPDATE


type Msg
    = NoOp
    | Select Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Select id ->
            let
                select item =
                    if item.id == id then
                        { item | selected = True }

                    else
                        { item | selected = False }
            in
            { model | items = List.map select model.items }



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [] <|
        row
            [ width fill, spacing 30, height fill ]
            [ sideBar model
            , mainBody
            ]


sideBar : Model -> Element Msg
sideBar model =
    column
        [ width (fillPortion 1)
        , height fill
        , Background.color colorBackground
        ]
        (makeSidebarItems model)


workSpace : Element Msg
workSpace =
    el
        [ width fill
        , paddingEach { top = 20, bottom = 30, left = 20, right = 20 }
        , pointer
        , Background.color colorBackground
        , Font.color (rgb255 255 255 255)
        , Font.size 15
        , Font.family fontFamily
        , Font.bold
        ]
        (text "MySlack")


channelHead : Element Msg
channelHead =
    el
        [ width fill
        , paddingEach { top = 5, bottom = 8, left = 20, right = 20 }
        , pointer
        , Background.color colorBackground
        , Font.color colorFontNormal
        , Font.size 15
        , Font.family fontFamily
        ]
        (text "Peeps")


makeSidebarItems : Model -> List (Element Msg)
makeSidebarItems model =
    [ workSpace, channelHead ] ++ List.map sideBarItem model.items


sideBarItem : Item -> Element Msg
sideBarItem item =
    let
        bcolor =
            if item.selected then
                colorSelected

            else
                colorBackground

        bfcolor =
            if item.selected then
                colorFontSelected

            else
                colorFontNormal

        bmcolor =
            if item.selected then
                colorSelected

            else
                colorMouseOver
    in
    el
        [ width fill
        , paddingXY 20 5
        , pointer
        , Background.color bcolor
        , Font.color bfcolor
        , Font.size 15
        , Font.family fontFamily
        , Element.mouseOver
            [ Background.color bmcolor
            , Font.color colorFontSelected
            ]
        , Events.onClick (Select item.id)
        ]
        (text item.name)


mainBody : Element msg
mainBody =
    column [ width (fillPortion 6), height fill ] []



-- Change list of items to dict of items, keyed by id?
-- Set selectedId in model
-- On change, update status of prev selected element, then update new selection,
-- then update selectedId
-- Is this what Keyed is for in elm-ui?
-- Should each sidebar element be a row containing an element?  Does this give more control over the contents?
