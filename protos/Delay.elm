module Delay exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time
import Task
import Process

delay : Time.Time -> msg -> msg
delay time msg =
  Process.sleep time
  |> Task.perform (\_ -> msg)

main =
  beginnerProgram { model = 0, view = view, update = update }

view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]
    , button [ onClick (delay (Time.second * 1) <| Increment) ] [ text "Delay Increment" ]
    ]

type Msg =
  Increment
  | Decrement
  | Reset

update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

    Reset ->
      0
