module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }

type alias Target =
  { id : Int
  , hp : Int
  }

type alias Model =
  { exp : Int
  , targetUid : Int
  , targets : List Target
  }

init : (Model, Cmd Msg)
init =
  ({ exp = 0
  , targetUid = 2
  , targets = [(Target 0 100), (Target 1 100), (Target 2 100), (Target 3 100)]
  }, Cmd.none)

type Msg
  = HitTarget Int

playerDamage : Int -> Int
playerDamage exp = round (10 * 1.2 ^ toFloat (expToLevel exp))

expToLevel : Int -> Int
expToLevel exp = round (toFloat exp / 10 ) + 1

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    HitTarget id ->
      let
        targetAlive t = t.hp > 0
        level = expToLevel model.exp
        currentDamage = playerDamage level
        targetWillDie = List.any (\t -> t.id == id && currentDamage >= t.hp) model.targets
        updatedExp = if targetWillDie then model.exp + 8 else model.exp
        damageTarget t = if t.id == id then { t | hp = t.hp - currentDamage } else t
      in
        ({ model
          | targets =
            List.map damageTarget model.targets
            |> List.filter targetAlive
          , exp = updatedExp
        }, Cmd.none)

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
  let
    level = expToLevel model.exp
  in
    div []
      [ div [] [ text ("Experience: " ++ toString model.exp) ]
      , div [] [ text ("Level: " ++ toString level) ]
      , div [] [ text ("Damage: " ++ toString (playerDamage level)) ]
      ]

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "WoS"]
    , viewStats model
    , viewTargets model.targets
  ]
