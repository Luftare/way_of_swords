module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main : Program Never Model Msg
main =
  beginnerProgram
    { model = model, update = update, view = view }

type alias Todo =
  { identifier: Int
  , name : String
  }

type alias Model =
  { newTodoName : String
  , todos : List Todo
  , idCounter : Int
  }

model : Model
model =
  { newTodoName = "Jou!"
  , todos = []
  , idCounter = 1
  }

type Msg
  = Add
  | Remove Int
  | UpdateNewTodoName String

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateNewTodoName text ->
      { model | newTodoName = text }
    Add ->
      { model | todos = (Todo { identifier = 4, name = "jaa" }) :: model.todos }
    Remove todoId ->
      model

todoItem : Todo -> Html Msg
todoItem todo =
  li [] [text todo.name]

todoList : List Todo -> Html Msg
todoList todos =
  let
    children = List.map todoItem todos
  in
    ul [] children

view : Model -> Html Msg
view model =
  div []
    [ div [] [text model.newTodoName]
    , input [type_ "text", value model.newTodoName, onInput UpdateNewTodoName] []
    , button [onClick Add] [text "Add"]
    , todoList model.todos
    ]
