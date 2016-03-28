import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL

type alias Task = {
  name : String,
  completed : Bool
  }

type TaskFilter
  = All
  | Completed
  | Pending

initialModel = {
  tasks = [
    Task "get milk" True,
    Task "call Mom" False,
    Task "learn Elm" False
    ],
  filter = Completed
  }


-- VIEW

crossedOut completed = case completed of
  True -> style [ ("text-decoration", "line-through") ]
  False -> style [ ]


taskLi task = li [ crossedOut task.completed ] [
  text task.name
  ]

filterVisibleTasks model =
  case model.filter of
    All ->
      model.tasks
    Completed ->
      List.filter (\t -> t.completed == True) model.tasks
    Pending ->
      List.filter (\t -> t.completed == False) model.tasks 


taskList model = ul [ ] (List.map taskLi (filterVisibleTasks model))


taskForm = div [ ] [
  input [ type' "text" ] [ ],
  button [ ] [ text "Add Task" ]
  ]


filterButtons = div [ ] [
  button [ ] [ text "All" ],
  button [ ] [ text "Pending" ],
  button [ ] [ text "Completed" ]
  ]

view model = div [ ] [
  (taskList model),
  taskForm,
  filterButtons
  ]

main = view initialModel
