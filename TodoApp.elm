import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)

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

type Message
  = NoOp
  | ToggleCompleted Int
  | DeleteTask Int
  | Filter TaskFilter
  | AddTask
  | UpdateTaskInput String

update message model =
  case message of
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


taskLi task = li
  [ crossedOut task.completed, onClick (ToggleCompleted task.id) ]
  [ text task.name ]

filterVisibleTasks model =
  case model.filter of
    All ->
      model.tasks
    Completed ->
      List.filter (\t -> t.completed == True) model.tasks
    Pending ->
      List.filter (\t -> t.completed == False) model.tasks 


taskList model = ul [ ] (List.map (taskLi) (filterVisibleTasks model))


taskForm model = div [ ] [
  input [ type' "text", onInput UpdateTaskInput, value model.taskInput ] [ ],
  button [ onClick AddTask ] [ text "Add Task" ]
  ]


filterButtons = div [ ] [
  button [ onClick (Filter All) ] [ text "All" ],
  button [ onClick (Filter Pending) ] [ text "Pending" ],
  button [ onClick (Filter Completed) ] [ text "Completed" ]
  ]

view model = div [ ] [
  taskList model,
  taskForm model,
  filterButtons
  ]

main =  App.beginnerProgram
  { model = initialModel,
    view = view,
    update = update
  }
