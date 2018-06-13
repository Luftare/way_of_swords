module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import Time exposing (Time, second)
import Task
import Process

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
  , level : Int
  , uid : Int
  , targets : List Target
  }

delay : Time.Time -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.perform (\_ -> msg)

init : (Model, Cmd Msg)
init =
  ({ exp = 0
  , level = 1
  , uid = 3
  , targets = []
  }, delay 0 <| SpawnTarget)


playerDamage : Int -> Int
playerDamage level = round (10 * 1.2 ^ (toFloat level))

requiredExpForNextLevel : Int -> Int
requiredExpForNextLevel level = 10

type Msg
  = HitTarget Int
  | SpawnTarget

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    HitTarget id ->
      let
        targetAlive t = t.hp > 0
        currentDamage = playerDamage model.level
        targetWillDie = List.any (\t -> t.id == id && currentDamage >= t.hp) model.targets
        expGain = if targetWillDie then 8 else 0
        willLevelUp = (expGain + model.exp) >= (requiredExpForNextLevel model.level)
        levelGain = if willLevelUp then 1 else 0
        newLevel = model.level + levelGain
        newExp = if willLevelUp then model.exp + expGain - (requiredExpForNextLevel model.level) else model.exp + expGain
        damageTarget t = if t.id == id then { t | hp = t.hp - currentDamage } else t
        shouldSpawnTarget = List.length model.targets < 6
        commandMsg = if targetWillDie && shouldSpawnTarget then [delay (second * 2) <| SpawnTarget] else []
      in
        { model
          | targets =
            List.map damageTarget model.targets
            |> List.filter targetAlive
          , exp = newExp
          , level = newLevel
        } ! commandMsg
    SpawnTarget ->
      let
        shouldSpawnTarget = List.length model.targets < 6
        commandMsg = if shouldSpawnTarget then [delay (second * 1) <| SpawnTarget] else []
      in
        { model | targets = model.targets ++ [ Target model.uid 100 ], uid = model.uid + 1 } ! commandMsg

renderTarget : Target -> Html Msg
renderTarget target =
  div [onMouseDown (HitTarget target.id)] [ text ("Target with hp: " ++ toString target.hp) ]

renderTargets : List Target -> Html Msg
renderTargets targets =
  let
    children
      = List.map renderTarget targets
  in
    div [] children

renderStats : Model -> Html Msg
renderStats model =
  div []
    [ div [] [ text ("Experience: " ++ toString model.exp) ]
    , div [] [ text ("Level: " ++ toString model.level) ]
    , div [] [ text ("Damage: " ++ toString (playerDamage model.level)) ]
    ]

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "WoS"]
    , renderStats model
    , renderTargets model.targets
  ]
