module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)

main : Program Never Model Msg
main =
  beginnerProgram
    { model = model, update = update, view = view }

type alias Target =
  { id : Int
  , hp : Int
  }

type alias Model =
  { exp : Int
  , level : Int
  , targetUid : Int
  , targets : List Target
  }

initialTargetsCount = 4

model : Model
model =
  { exp = 0
  , level = 1
  , targetUid = 2
  , targets = [(Target 0 100), (Target 1 100), (Target 2 100), (Target 3 100)]
  }

type Msg
  = HitTarget Int
  | LevelUp

playerDamage : Int -> Int
playerDamage level = round (10 * 1.2 ^ toFloat level)

update : Msg -> Model -> Model
update msg model =
  case msg of
    HitTarget id ->
      let
        targetAlive t = t.hp > 0
        currentDamage = playerDamage model.level
        targetWillDie = List.any (\t -> t.id == id && currentDamage >= t.hp) model.targets
        newLevel = if targetWillDie then model.level + 1 else model.level
        updateTarget t = if t.id == id then { t | hp = t.hp - currentDamage } else t
      in
        { model
          | targets =
            List.map updateTarget model.targets
            |> List.filter targetAlive
          , level = newLevel
        }
    LevelUp ->
      model

viewTarget : Target -> Html Msg
viewTarget target =
  div [onMouseDown (HitTarget target.id)] [ text ("Target with hp: " ++ toString target.hp) ]

viewTargets : List Target -> Html Msg
viewTargets targets =
  let
    children
      = List.map viewTarget targets
  in
    div [] children

viewStats : Model -> Html Msg
viewStats model =
  div []
    [ div [] [ text ("Level: " ++ toString model.level) ]
    , div [] [ text ("Damage: " ++ toString (playerDamage model.level)) ]
    ]

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "WoS"]
    , viewStats model
    , viewTargets model.targets
  ]
