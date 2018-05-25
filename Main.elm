import Jason.Decode exposing (..)
import Native.Jason.Decode

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
  [ describe "strings"
    [ it "decodes strings" <| eql 
      (Ok "hi")
      (string (Json.Encode.string "hi"))
    , it "fails on not-strings" <| isErr <|
      string (Json.Encode.int 42)
    ]
  , describe "ints"
    [ it "decodes int" <| eql 
      (Ok 42)
      (int (Json.Encode.int 42))
    , it "fails on not-int" <| isErr <|
      int (Json.Encode.string "hi")
    , it "fails on float" <| isErr <|
      int (Json.Encode.float 3.14)
    ]
  , describe "arrays"
    [ it "decodes an empty array" <| eql 
      (Ok Array.empty)
      (Native.Jason.Decode.array (Json.Encode.array Array.empty))
    , it "fails on not-array" <| isErr <|
      Native.Jason.Decode.array (Json.Encode.int 42)
    , it "fails on object" <| isErr <|
      Native.Jason.Decode.array (Json.Encode.object [])
    , it "decodes an array with an element" <| eql 
      (Ok <| Array.fromList [Json.Encode.int 1])
      (Native.Jason.Decode.array (Json.Encode.array <| Array.fromList [Json.Encode.int 1]))
    , it "is convenient to decode children" <| eql 
      (Ok <| Array.fromList [1])
      (array int (Json.Encode.array <| Array.fromList [Json.Encode.int 1]))
    , it "maintains array order" <| eql 
      (Ok <| Array.fromList [1, 2, 3])
      (array int (Json.Encode.array <| Array.fromList (List.map Json.Encode.int [1, 2, 3])))
    ]
  , describe "lists"
    [ it "decodes an empty list" <| eql 
      (Ok [])
      (list int (Json.Encode.list []))
    , it "decodes a list with an element" <| eql 
      (Ok [1])
      (list int (Json.Encode.list <| [Json.Encode.int 1]))
    , it "maintains list order" <| eql 
      (Ok [1, 2, 3])
      (list int (Json.Encode.list <| List.map Json.Encode.int [1, 2, 3]))
    ]
  , describe "objects"
    [ it "decodes an untyped empty object" <| eql 
      (Ok [])
      (Native.Jason.Decode.object (Json.Encode.object []))
    , it "decodes an untyped object with an element" <| eql 
      (Ok [ ("one", Json.Encode.int 1) ])
      (Native.Jason.Decode.object <| (Json.Encode.object [("one", Json.Encode.int 1)]))
    , it "decodes an simple empty object" <| eql 
      (Ok [])
      (keyValuePairs int (Json.Encode.object []))
    , it "decodes an simple object with one element" <| eql 
      (Ok [("one", 1)])
      (keyValuePairs int (Json.Encode.object [("one", Json.Encode.int 1)]))
    , it "pick out one field" <| eql 
      (Ok 1)
      (field "one" int (Json.Encode.object [("one", Json.Encode.int 1)]))
    , it "reports downstream decoder errors" <| eql 
      (Err "Expected an int: foo")
      (field "one" int (Json.Encode.object [("one", Json.Encode.string "foo")]))
    , it "reports field not found" <| eql 
      (Err "Field not found: one")
      (field "one" int (Json.Encode.object [("two", Json.Encode.int 1)]))
    ]
  ]

isErr : Result err v -> Expectation
isErr result =
  Expectation
    ("Expected Err, got " ++ (toString result))
    (\() -> case result of
      Err _ -> True
      a -> False
    )
