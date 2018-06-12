module Subs exposing (..)

import Html exposing (Html, div, text, program)
import Mouse
import Keyboard


-- MODEL

type alias Model =
    String

init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )

-- MESSAGES

type Msg
    = MouseMsg Mouse.Position
    | KeyMsg Keyboard.KeyCode

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ text model ]

-- UPDATE

mouseString position =
  "x: " ++ (toString position.x) ++ " y: " ++ (toString position.y)

keyString code =
  "Key code: " ++ (toString code)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMsg position ->
            ( mouseString position, Cmd.none )

        KeyMsg code ->
            ( keyString code, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.moves MouseMsg
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
