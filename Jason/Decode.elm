module Jason.Decode exposing (..)

import Native.Jason.Decode

import Json.Encode exposing (Value)
import Array exposing (Array)

type alias Decoder a = Value -> Result String a

string : Decoder String
string = Native.Jason.Decode.string

int : Decoder Int
int = Native.Jason.Decode.int

arrayOfValues : Decoder (Array Value)
arrayOfValues = Native.Jason.Decode.array

array : Decoder a -> Decoder (Array a)
array decoder =
  arrayOfValues
    >> Result.andThen
      (Array.map decoder
        >> Array.foldl (Result.map2 Array.push) (Ok Array.empty)
      )

listOfValues : Decoder (List Value)
listOfValues = Native.Jason.Decode.list

list : Decoder a -> Decoder (List a)
list decoder =
  listOfValues
    >> Result.andThen
      (List.map decoder
        >> List.foldr (Result.map2 (::)) (Ok [])
      )

objectOfValues : Decoder (List (String, Value))
objectOfValues = Native.Jason.Decode.object

keyValuePairs : Decoder a -> Decoder (List (String, a))
keyValuePairs decoder =
  objectOfValues
    >> Result.andThen
      (List.map (\(key,val) -> decoder val |> Result.map (\t -> (key,t)))
        >> List.foldr (Result.map2 (::)) (Ok [])
      )

fieldValue : String -> Decoder Value
fieldValue = Native.Jason.Decode.field

field : String -> Decoder a -> Decoder a
field key decoder v =
  fieldValue key v
    |> Result.andThen decoder

map : (a -> out) -> Decoder a -> Decoder out
map f a v =
  Result.map f (a v)

map2 : (a -> b -> out) -> Decoder a -> Decoder b -> Decoder out
map2 f a b v =
  Result.map2 f (a v) (b v)

andThen : (a -> Decoder b) -> Decoder a -> Decoder b
andThen f decoder v =
  case decoder v of
    Ok a -> f a v
    Err err -> Err err

succeed : a -> Decoder a
succeed a v = Ok a

fail : String -> Decoder a
fail err v = Err err
