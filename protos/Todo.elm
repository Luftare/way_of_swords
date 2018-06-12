module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }

--model

type alias Model =
    { todo : String
    , todos : List String
    }

model : Model
model =
    { todo = ""
    , todos = []
    }

--update

type Msg
    = UpdateText String
    | AddItem
    | RemoveItem String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateText text ->
            { model | todo = text }

        AddItem ->
            { model | todos = model.todo :: model.todos }

        RemoveItem text ->
            { model | todos = List.filter (\t -> t /= text) model.todos }

--view

todoItem : String -> Html Msg
todoItem todo =
    li []
        [ text todo
        , button [ onClick (RemoveItem todo) ] [ text "X" ]
        ]


todoList : List String -> Html Msg
todoList todos =
    let
        children =
            List.map todoItem todos
    in
        ul [] children

view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", onInput UpdateText, value model.todo ] []
        , button [ onClick AddItem ] [ text "Add Todo" ]
        , div [] [ text model.todo ]
        , todoList model.todos
        ]
