module OnInput where

import Html.Events exposing (..)
import Signal

onInput address f =
  on "input" targetValue (\v -> Signal.message address (f v))