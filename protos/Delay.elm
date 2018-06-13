module Delay exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time, second)
import Task
import Process

type alias Model =
  Int

main : Program Never Model Msg
main =
    program
        { init = (0, Cmd.none)
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }

delay : Time.Time -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.perform (\_ -> msg)

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset and add 5 after sec" ]
    , button [ onClick DelayedIncrement ] [ text "Delay Increment" ]
    ]

type Msg =
  Increment
  | Add Int
  | Decrement
  | Reset
  | DelayedIncrement

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      (model + 1) ! []

    Add n ->
      (model + n) ! []

    Decrement ->
      (model - 1) ! []

    Reset ->
      0 ! [delay (second * 1) <|  Add 5]

    DelayedIncrement ->
      model ! [delay (second * 1) <|  Increment]
