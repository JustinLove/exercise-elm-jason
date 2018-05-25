import Jason.Decode exposing (..)

import Expectation exposing (eql, isTrue, isFalse, Expectation)
import Test exposing (it, describe, Test)
import Runner exposing (runAll)

import Html exposing (Html)
import Json.Encode
import Array

main : Html msg
main = runAll all

all : Test
all = describe "decoding"
  [ it "decodes strings" <| eql 
    (Ok "hi")
    (string (Json.Encode.string "hi"))
  , it "fails on not-strings" <| isErr <|
    string (Json.Encode.int 42)
  , it "decodes int" <| eql 
    (Ok 42)
    (int (Json.Encode.int 42))
  , it "fails on not-int" <| isErr <|
    int (Json.Encode.string "hi")
  , it "fails on float" <| isErr <|
    int (Json.Encode.float 3.14)
  , it "decodes an empty array" <| eql 
    (Ok Array.empty)
    (array (Json.Encode.array Array.empty))
  , it "fails on not-array" <| isErr <|
    array (Json.Encode.int 42)
  , it "fails on object" <| isErr <|
    array (Json.Encode.object [])
  , it "decodes an array with an element" <| eql 
    (Ok <| Array.fromList [Json.Encode.int 1])
    (array (Json.Encode.array <| Array.fromList [Json.Encode.int 1]))
  ]

isErr : Result err v -> Expectation
isErr result =
  Expectation
    ("Expected Err, got " ++ (toString result))
    (\() -> case result of
      Err _ -> True
      a -> False
    )
