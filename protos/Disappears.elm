module Delay exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time, second)
import Task
import Process

type alias Model =
  { entries : List Int
  , uid : Int
  }

init : Model
init =
  { entries = []
  , uid = 0
  }

main : Program Never Model Msg
main =
    program
        { init = (init, Cmd.none)
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
    [ button [ onClick (Add model.uid)] [ text "Add" ]
    , div[] (List.map (\a -> div [] [text (toString a)]) model.entries)
    ]

type Msg
  = Add Int
  | Remove Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add n ->
      { model | entries = model.entries ++ [n] , uid = model.uid + 1 } ! [delay (second * 1) <|  (Remove n)]
    Remove n ->
      {model | entries = List.filter (\a -> a /= n) model.entries } ! []
