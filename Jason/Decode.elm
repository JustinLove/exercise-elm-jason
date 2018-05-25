module Jason.Decode exposing (..)

import Native.Jason.Decode

import Json.Encode exposing (Value)
import Array exposing (Array)

string : Value -> Result String String
string = Native.Jason.Decode.string

int : Value -> Result String Int
int = Native.Jason.Decode.int

array : Value -> Result String (Array Value)
array = Native.Jason.Decode.array
