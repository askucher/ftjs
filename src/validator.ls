parser = require \./parser.js
p = 
    obj-to-pairs:  (object) ->
      [[key, value] for key, value of object]
    pairs-to-obj: (object) ->
      {[x.0, x.1] for x in object}
    map: (f, xs) -->
      [f x for x in xs]
    tail: (xs) ->
      return void unless xs.length
      xs.slice 1
    concat: (xss) ->
      [].concat.apply [], xss
    filter: (f, xs)-->
        xs.filter(f)
compile = (str)->
  mask = str.match("/(.+)/([ig]?)")
  new RegExp(mask.1, mask.2)
get-type = (obj)->
  return switch typeof! obj
     case \Object then \Complex
     case \Undefined then \Global.Undefined
     case \Null then \Global.Null
     case \String then \RegularExpression
     case \Boolean then \Global.Boolean
     case \Number then \Global.Number
     case \Array then \ArrayType
module.exports = (source)->
    registry =
        source |> p.obj-to-pairs
               |> p.map (-> [it.0, parser.compile it.1]) 
               |> p.pairs-to-obj
    
    console.log registry
    find-type = (scope, typename)->
       bundle_o = registry[scope]
       return bundle_o if typeof! bundle_o is \String
       return "Scope '#{scope}' not found" if not bundle_o?
       type = bundle_o[typename]
       return "Type '#{typename}' is not found in scope '#{scope}'" if not type?
       return type
    lookup-type= (scope, type)->
         found =
               find-type scope, type.body
         get-expected-types scope, found
    lookup-invoke-function-type = (scope, type)->
         new-type =
           type: \Internal.Extended
           basetype: find-type scope, type.body.0
           extensions: type.body |> p.tail
         [new-type]
    lookup-discrimination-type = (scope, type)->
        type.body |> p.map get-expected-types scope 
                  |> p.concat
    get-expected-types = (scope, type)-->
        switch type.type
          case \Type 
             lookup-type scope, type
          case \InvokeFunction
             lookup-invoke-function-type scope, type
          case \Discrimination
             lookup-discrimination-type scope, type
          else
           [type]
    validate-complex-type = (scope, type, obj)->
      return "Type #{type.body} isnt Complex" if type.type isnt \Complex
      validate = (field)->
        result = validate-type scope, field.body, obj[field.name]
        switch typeof! result 
          case \String 
            return "'Field #{field.name}': { #result }"
          else
            result
      #throw "type.fields isnt Array for type #{type.body}" if typeof! type.fields isnt \Array
      result = 
        type.fields |> p.map validate
      return yes if result.filter(-> it is yes).length is result.length 
      return "{ " + result.filter(-> it isnt yes).join(", ") + " }"
    parse-invoke = (expression)->
       parsed = expression.match /([A-Z][a-z0-9]+)\(([^\)]+)\)/
       name: parsed?1
       params: parsed?2?split?(",") ? []
    invoke-regular-expression = (body, params, obj)->
        return "Object should have type Global.String" if typeof! obj isnt \String
        state =
            str: body.body
        replace = (param)->
           find = new RegExp("#\{#{param.name}\}")
           state.str = state.str.replace(find, param.value)
        params.for-each replace
        result = obj.match compile(state.str)
        return yes if result?
        return "'#{obj}' does not match to #{state.str}"
    invoke-operation-with-value = (body, params, obj)->
        state = 
            func: null
        return "Body expected started with 'this'. Actual value is '#{body.body.substr(0, 4)}' in '#{body.body}'" if body.body.substr(0, 4) isnt \this
        try 
          state.func = eval "test = function (#{params.map(-> it.name).join(',')}) { return #{body.body} }" 
        catch err 
          return "Syntax error in #{body.body} : #{err.message ? err}"
        result = state.func.apply obj, params.map(-> it.value)
        return yes if result is yes
        params-str = params.map(-> "'#{it.name}' = '#{it.value}'").join(", ")
        return "'#{obj}' does not pass the condition '#{body.body}' with params #{params-str}"
    invoke-function = (func, params, obj)->
        switch func.body.type
          case "RegularExpression" then invoke-regular-expression func.body, params, obj 
          case "OperationWithValue" then invoke-operation-with-value func.body, params, obj
          else "Function #{func.body.type} is not supported"
    validate-value = (scope, obj, type)-->
        obj-type = get-type obj
        switch type.type
           case \Internal.Extended
               #console.log type.extensions
               #console.log type.basetype.extensions.map(make-function)
               result = validate-value scope, obj, type.basetype
               return result if result isnt yes 
               apply = (invoke)->
                   func = type.basetype.extensions.filter(-> it.name is invoke.name).0
                   if not func?
                     return "Function #{invoke.name} is not found"
                   applied-params = []
                   apply-param = (param, index)->
                       applied-params.push do 
                           name: param 
                           value: invoke.params[index]
                   func.params.for-each apply-param
                   invoke-function func, applied-params, obj
                   
               result = type.extensions.map(parse-invoke).map(apply)
               return yes if result.filter(-> it is yes).length is result.length
               return result.filter(-> it isnt yes).join("; ")
                
           case \String 
               result = type.body.index-of(obj) > -1
               return yes if result is yes
               return "'#{obj}' is not '#{type.body}'"
           case \RegularExpression
               result = obj?match?(compile type.body) ? null
               return yes if result?
               return "#{obj} does not match to regular expression #{type.body}"
           case \ExportType
               parts = type.body.split(\.)
               switch
                case parts.length isnt 2
                   return "Export Type #{type.body} is not valid"
                case parts.0 is \Global
                   result = obj-type is type.body
                   return yes if result is yes
                   return "Type '#{obj-type} isnt #{type.body}'"
                else 
                   validate type.body, obj
                   
           case \ArrayType
               return "Object Type is not And ArrayType" if obj-type isnt \ArrayType
               array-type = find-type scope, type.body
               switch typeof! array-type 
                   case \String 
                     return array-type
                   else
                     items = obj.map(-> validate-expression scope, array-type, it)
                     
                     return yes if items.length is items.filter(-> it is yes).length 
                     return items.filter(-> it is no).join("; ")
                      
           else 
               return type.type
    validate-expression = (scope, type, obj)->
     types = get-expected-types scope, type
     result = types.map(validate-value scope, obj)
     switch
       case type.type is \Discrimination and result.filter(-> it is yes).length > 0
         return true
       case result.filter(-> it is yes).length is result.length 
         return true
       else 
         result.filter(-> it isnt yes).join("; ")
    validate-type = (scope, type, obj)->
      switch get-type obj
        case \Complex 
          return validate-complex-type scope, type, obj
        else 
          return validate-expression scope, type, obj
    validate = (typename, obj)->
      pair = typename?split?(\.) ? []
      if pair.length isnt 2
         return "Type mask must be 'Scope.Typename'"
      scope = pair.0
      name = pair.1
      type = find-type scope, name
      return type if typeof! type is \String 
      validate-type scope, type, obj
    validate.registry = registry
    validate.syntax-check = ->
        result = registry |> p.obj-to-pairs |> p.filter (-> typeof! it.1 is \String) |> p.map (-> "'#{it.0}': { #{it.1} }")
        return yes if result.length is 0
        return result.join("; ")
    validate
      
    
        
    
