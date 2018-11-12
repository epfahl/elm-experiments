module Session exposing (Session, fromUser, navKey)

import Browser.Navigation as Nav


type Session
    = LoggedIn Nav.Key User
    | Guest Nav.Key


type User
    = User String


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key


fromUser : Nav.Key -> Maybe User -> Session
fromUser key maybeUser =
    case maybeUser of
        Just user ->
            LoggedIn key user

        Nothing ->
            Guest key
