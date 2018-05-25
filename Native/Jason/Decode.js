var _user$project$Native_Jason_Decode = function() {
  var Ok = _elm_lang$core$Result$Ok
  var Err = _elm_lang$core$Result$Err

  var string = function(value) {
    if (typeof(value) == "string") {
      return Ok(value)
    } else {
      return Err("Expected a string: " + value.toString())
    }
  }

  var int = function(value) {
    if (typeof(value) == "number" && value == Math.floor(value)) {
      return Ok(value)
    } else {
      return Err("Expected an int: " + value.toString())
    }
  }

  var array = function(value) {
    if (typeof(value) == "object" && value.constructor == Array) {
      return Ok(_elm_lang$core$Native_Array.fromJSArray(value))
    } else {
      return Err("Expected array: " + value.toString())
    }
  }

  var list = function(value) {
    if (typeof(value) == "object" && value.constructor == Array) {
      return Ok(_elm_lang$core$Native_List.fromArray(value))
    } else {
      return Err("Expected list: " + value.toString())
    }
  }

  var object = function(value) {
    if (typeof(value) == "object" && value.constructor != Array) {
      var fields = []
      for (var key in value) {
        fields.push(_elm_lang$core$Native_Utils.Tuple2(key, value[key]))
      }
      return Ok(_elm_lang$core$Native_List.fromArray(fields))
    } else {
      return Err("Expected object: " + value.toString())
    }
  }

  return {
    string: string,
    int: int,
    array: array,
    list: list,
    object: object,
  }
}();
