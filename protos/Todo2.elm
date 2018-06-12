module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main : Program Never Model Msg
main =
  beginnerProgram
    { model = model, update = update, view = view }

type alias Todo =
  { id : Int
  , name : String
  , done : Bool
  }

type alias Model =
  { newTodoName : String
  , todos : List Todo
  , uid : Int
  }

model : Model
model =
  { newTodoName = "Jou!"
  , todos = []
  , uid = 1
  }

newTodo : String -> Int -> Todo
newTodo name id =
  { name = name
  , id = id
  , done = False
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
      { model
      | uid = model.uid + 1
      , newTodoName = ""
      , todos = model.todos ++ [ newTodo model.newTodoName model.uid ]
      }
    Remove id ->
      { model | todos = List.filter (\a -> a.id /= id) model.todos }

todoItem : Todo -> Html Msg
todoItem todo =
  li []
    [ text todo.name
    , button [onClick (Remove todo.id)] [text "X"]
    ]

todoList : List Todo -> Html Msg
todoList todos =
  let
    children = List.map todoItem todos
  in
    ul [] children

view : Model -> Html Msg
view model =
  div []
    [ input [type_ "text", value model.newTodoName, onInput UpdateNewTodoName] []
    , button [onClick Add] [text "Add"]
    , todoList model.todos
    ]
