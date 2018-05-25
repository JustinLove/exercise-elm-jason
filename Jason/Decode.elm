module Jason.Decode exposing (..)

import Native.Jason.Decode

import Json.Encode exposing (Value)
import Array exposing (Array)

string : Value -> Result String String
string = Native.Jason.Decode.string

int : Value -> Result String Int
int = Native.Jason.Decode.int

arrayOfValues : Value -> Result String (Array Value)
arrayOfValues = Native.Jason.Decode.array

array : (Value -> Result String a) -> Value -> Result String (Array a)
array decoder v =
  (arrayOfValues v)
    |> Result.andThen
      (Array.map decoder
        >> Array.foldl (Result.map2 Array.push) (Ok Array.empty)
      )
