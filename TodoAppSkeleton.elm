import Html exposing (..)
import Html.Attributes exposing (..)


crossedOut = style [ ("text-decoration", "line-through") ]


taskList = ul [ ] [ 
  li [ crossedOut ] [ text "get milk" ],
  li [ ] [ text "call Mom" ],
  li [ ] [ text "learn Elm" ]
  ]


taskForm = div [ ] [
  input [ type' "text" ] [ ],
  button [ ] [ text "Add Task" ]
  ]


filterButtons = div [ ] [
  button [ ] [ text "All" ],
  button [ ] [ text "Pending" ],
  button [ ] [ text "Completed" ]
  ]


main = div [ ] [
  taskList,
  taskForm,
  filterButtons
  ]
