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


{-| An empty block element that receives only styling attributes.
-}
block : List (Attribute Msg) -> Element Msg
block attrs =
    el attrs (el [] Element.none)


props =
    {}



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
    Element.layout [] <|
        block []
