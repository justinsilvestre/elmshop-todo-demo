import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)

import StartApp.Simple as StartApp
import Html exposing (..)
import Html.Attributes exposing (..)

import OnInput exposing (..)

-- MODEL

type alias Task = {
  name : String,
  completed : Bool,
  id : Int
  }

type TaskFilter
  = All
  | Completed
  | Pending

initialModel = {
  tasks = [
    Task "get milk" True 1,
    Task "call Mom" False 2,
    Task "learn Elm" False 3
    ],
  filter = All,
  nextId = 4,
  taskInput = ""
  }


-- UPDATE

type Action
  = NoOp
  | ToggleCompleted Int
  | DeleteTask Int
  | Filter TaskFilter
  | AddTask
  | UpdateTaskInput String

update action model =
  case action of
    NoOp ->
      model

    ToggleCompleted id ->
      let
        updateTask t = 
          if t.id == id then { t | completed = (not t.completed) } else t
      in
        { model | tasks = List.map updateTask model.tasks }

    DeleteTask id ->
      { model | tasks = List.filter (\t -> t.id /= id) model.tasks }

    Filter filter ->
      { model | filter = filter }        

    AddTask ->
      let
        taskToAdd = Task model.taskInput False model.nextId
      in
        { model |
          tasks = taskToAdd :: model.tasks,
          nextId = model.nextId + 1,
          taskInput = ""
        }

    UpdateTaskInput content ->
      { model | taskInput = content }


-- VIEW

crossedOut completed = case completed of
  True -> style [ ("text-decoration", "line-through") ]
  False -> style [ ]


taskLi address task = li
  [ crossedOut task.completed, onClick address (ToggleCompleted task.id) ]
  [ text task.name ]

filterVisibleTasks address model =
  case model.filter of
    All ->
      model.tasks
    Completed ->
      List.filter (\t -> t.completed == True) model.tasks
    Pending ->
      List.filter (\t -> t.completed == False) model.tasks 


taskList address model = ul [ ] (List.map (taskLi address) (filterVisibleTasks address model))


taskForm address = div [ ] [
  input [ type' "text", onInput address UpdateTaskInput ] [ ],
  button [ onClick address AddTask ] [ text "Add Task" ]
  ]


filterButtons address= div [ ] [
  button [ onClick address (Filter All) ] [ text "All" ],
  button [ onClick address (Filter Pending) ] [ text "Pending" ],
  button [ onClick address (Filter Completed) ] [ text "Completed" ]
  ]

view address model = div [ ] [
  taskList address model,
  taskForm address,
  filterButtons address
  ]

main =  StartApp.start
  { model = initialModel,
    view = view,
    update = update
  }
