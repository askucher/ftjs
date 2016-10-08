registry = require \./registry.js
p = require \prelude-ls
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
module.exports = (typedef)->
    types = registry.compile typedef
    find-type = (typename)->
       type = types[typename]
       return "Type #{typename} is not found" if not types[typename]?
       return type
    lookup-type= (type)->
         found =
               find-type type.body
         get-expected-types found
    lookup-invoke-function-type = (type)->
         new-type =
           type: \Internal.Extended
           basetype: find-type type.body.0
           extensions: type.body |> p.tail
         [new-type]
    lookup-discrimination-type = (type)->
        type.body |> p.map get-expected-types |> p.concat
    get-expected-types = (type)->
        switch type.type
          case \Type 
             lookup-type type
          case \InvokeFunction
             lookup-invoke-function-type type
          case \Discrimination
             lookup-discrimination-type type
          else
           [type]
    validate-complex-type = (type, obj)->
      validate = (field)->
        result = validate-type field.body, obj[field.name]
        switch typeof! result 
          case \String 
            return "'Field #{field.name}': { #result }"
          else
            result
      result = 
        type.fields |> p.map validate
      return yes if result.filter(-> it is yes).length is result.length 
      return "{ " + result.filter(-> it isnt yes).join(", ") + " }"
    validate-value = (obj, type)-->
        obj-type = get-type(obj)
        switch type.type
           case \Internal.Extended
               #console.log type.extensions
               #console.log type.basetype.extensions
               validate-value obj, type.basetype
           case \String 
               result = type.body.index-of(obj) > -1
               return yes if result is yes
               return "'#{obj}' is not '#{type.body}'"
           case \RegularExpression
               result = obj?match?(compile type.body) ? null
               return yes if result?
               return "#{obj} does not match to regular expression #{type.body}"
           case \ExportType
               result = obj-type is type.body
               return yes if result is yes
               return "Type '#{get-type(obj)} isnt #{type.body}'"
           case \ArrayType
               return "Object Type is not And ArrayType" if obj-type isnt \ArrayType
               array-type = find-type type.body
               switch typeof! array-type 
                   case \String 
                     return array-type
                   else
                     items = obj.map(-> validate-expression array-type, it)
                     return yes if items.length is items.filter(-> it is yes).length 
                     return items.filter(-> it is no).join("; ")
                      
           else 
               return type.type
    validate-expression = (type, obj)->
     types = get-expected-types type
     result = types.map(validate-value obj)
     switch 
       case type.type is \Discrimination and result.filter(-> it is yes).length > 0
         return true
       case result.filter(-> it is yes).length is result.length 
         return true
       else 
         result.filter(-> it isnt yes).join("; ")
    validate-type = (type, obj)->
      switch get-type obj
        case \Complex 
          return validate-complex-type type, obj
        else 
          return validate-expression type, obj
    validate = (typename, obj)->
      type = find-type typename
      switch typeof! type
        case \String 
          return type
        else
          return validate-type type, obj
    validate
      
    
        
    
