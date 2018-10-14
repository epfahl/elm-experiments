module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (src)
import Http
import Json.Decode as Decode
import Json.Encode as Encode



-- Constants and helpers


asinInfoUrl =
    "http://localhost:8765/rank"


explain =
    Element.explain Debug.todo



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { asins : List String
    , entryContent : String
    , infos : InfoDict
    }


type alias InfoDict =
    Dict String AsinInfo


type alias AsinInfo =
    { asin : String
    , rank : Int
    , time : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] "" Dict.empty, Cmd.none )



-- Update


type Msg
    = Entry String
    | SubmitAsin String
    | UpdateAsinInfo String
    | NewAsinInfo (Result Http.Error AsinInfo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        lenTrimmed string =
            string |> String.trim |> String.length
    in
    case msg of
        Entry content ->
            let
                newModel =
                    if lenTrimmed content == 0 then
                        model

                    else
                        { model | entryContent = content }
            in
            ( newModel, Cmd.none )

        SubmitAsin asin ->
            let
                newModel =
                    if lenTrimmed asin == 0 then
                        model

                    else
                        { model
                            | asins = asin :: model.asins
                            , entryContent = ""
                            , infos = Dict.insert asin (AsinInfo asin -1 "NA") model.infos
                        }
            in
            ( newModel, Cmd.none )

        UpdateAsinInfo asin ->
            ( model, getAsinInfo asin )

        NewAsinInfo result ->
            case Debug.log "result" result of
                Ok info ->
                    let
                        newInfos =
                            Dict.update
                                info.asin
                                (Maybe.map (\v -> info))
                                model.infos
                    in
                    ( { model | infos = newInfos }
                    , Cmd.none
                    )

                Err _ ->
                    ( model
                    , Cmd.none
                    )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    Element.layout [] <|
        column
            [ width fill
            , spacing 20
            ]
            [ viewAsinEntry model
            , viewAsinInfo model
            ]


viewAsinEntry : Model -> Element Msg
viewAsinEntry model =
    row
        [ width (px 600)
        , centerX
        , spacing 30
        , padding 20
        ]
        [ viewAsinEntryInput model
        , viewAsinEntryButton model
        ]


viewAsinEntryInput : Model -> Element Msg
viewAsinEntryInput { entryContent } =
    let
        ph =
            Input.placeholder [] <|
                el
                    [ centerY ]
                    (text "ASIN")
    in
    Input.text
        [ width (fillPortion 5)
        , height (px 50)
        ]
        { onChange = Entry
        , text = entryContent
        , placeholder = Just ph
        , label = Input.labelHidden "nothing to see here"
        }


viewAsinEntryButton : Model -> Element Msg
viewAsinEntryButton model =
    Input.button
        [ width (fillPortion 1)
        , height (px 50)
        , Background.color (rgb255 200 200 200)
        , Border.rounded 3
        ]
        { onPress = Just (SubmitAsin model.entryContent)
        , label = el [ centerX, centerY ] (text "Submit")
        }


viewAsinInfo : Model -> Element Msg
viewAsinInfo model =
    let
        infoElement asin info =
            let
                rankString =
                    if info.rank == -1 then
                        "NA"

                    else
                        String.fromInt info.rank
            in
            row [ width (px 800), height (px 30), spacing 20, padding 5 ]
                [ paragraph [ width (fillPortion 5) ]
                    [ text ("ASIN: " ++ info.asin ++ "  Rank: " ++ rankString)
                    ]
                , viewUpdateButton asin
                ]
    in
    column [ spacing 20 ] <|
        (model.infos
            |> Dict.map infoElement
            |> Dict.values
        )


viewUpdateButton : String -> Element Msg
viewUpdateButton asin =
    Input.button
        [ width shrink
        , padding 10
        , Font.size 16
        , Background.color (rgb255 200 200 200)
        , Border.rounded 3
        ]
        { onPress = Just (UpdateAsinInfo asin)
        , label = el [ centerX, centerY ] (text "Update")
        }



-- Http


getAsinInfo : String -> Cmd Msg
getAsinInfo asin =
    let
        body =
            asin
                |> Encode.string
                |> Http.jsonBody
    in
    Http.send NewAsinInfo (Http.post asinInfoUrl body asinInfoDecoder)



-- Decoders


asinInfoDecoder : Decode.Decoder AsinInfo
asinInfoDecoder =
    Decode.map3 AsinInfo
        (Decode.field "asin" Decode.string)
        (Decode.field "rank" Decode.int)
        (Decode.field "time" Decode.string)
