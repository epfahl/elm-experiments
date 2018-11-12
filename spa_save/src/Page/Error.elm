module Page.Error exposing (view)

import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)
import Session exposing (Session)



-- type Msg
--     = NoOp


view : { title : String, content : Html msg }
view =
    { title = "Error"
    , content =
        layout [] <|
            el
                [ centerX
                , centerY
                , Font.size 80
                , Font.color (rgb255 50 50 50)
                ]
                (text "Error!")
    }
