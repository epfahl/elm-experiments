module Page exposing (Page(..), view)

import Browser
import Route exposing (Route)
import Session exposing (Session)


type Page
    = Error
    | Home
    | Login

view : Page -> ?