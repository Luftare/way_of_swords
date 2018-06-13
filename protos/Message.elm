module Delay exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time, second)
import Task
import Process

type alias Message =
  { id : Int
  , text : String
  }

type alias Model =
  { entries : List Message
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
    [ button [ onClick (Add "Jou!!!")] [ text "Add" ]
    , div[] (List.map (\a -> div [] [text a.text]) model.entries)
    ]

type Msg
  = Add String
  | Remove Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add message ->
      { model | entries = model.entries ++ [ (Message model.uid message) ] , uid = model.uid + 1 } ! [delay (second * 1) <|  (Remove model.uid)]
    Remove id ->
      { model | entries = List.filter (\a -> a.id /= id) model.entries } ! []
