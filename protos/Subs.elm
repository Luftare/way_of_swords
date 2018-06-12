module Subs exposing (..)

import Html exposing (Html, div, text, program)
import Mouse
import Keyboard


-- MODEL

type alias Model =
    Int

init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )

-- MESSAGES

type Msg
    = MouseMsg Mouse.Position
    | KeyMsg Keyboard.KeyCode

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ text (toString model) ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMsg position ->
            ( position.x, Cmd.none )

        KeyMsg code ->
            ( code, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMsg
        , Keyboard.downs KeyMsg
        ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }