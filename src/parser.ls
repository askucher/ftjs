p = 
 tail: (xs) ->
  return void unless xs.length
  xs.slice 1
module.exports = do
    pattern =  
     //^
     (#.+)
     | ^(([A-Z][_a-zA-Z0-9]+)(\s[a-z][a-zA-Z0-9]+)+\s+:\s+(.+))$         # Function
     | ^(([A-Z][_a-zA-Z0-9]+)\s+:\s+(.+))$                               # Type
     | ^(([a-z_][_a-zA-Z0-9]+)\s+\:\s+(.+))$                             # Field
     | ^(-{3,})$                                                         # FieldStart
     | ^(([A-Z][_a-zA-Z0-9]+)\.{3})$                                     # TypeExtension
     | ^(([A-Z][_a-zA-Z0-9]+))$                                          # ComplexType
     //
    
    function-params = (str)->
      str.match(/[A-Z][_a-zA-Z0-9]+\s([^:]+)/).1.trim!.split(/\s+/)
    body-pattern =
     //
     (\/.+)                                                          # RegularExpression
     | ([^\|]+\|.+)                                                  # Discrimination  
     | .+([A-Z][a-zA-Z0-9]+\([^(]+\))                                # InvokeFunction
     | (\[[A-Z][a-zA-Z0-9]+\])                                       # ArrayType
     | (\@.+)                                                        # OperationWithValue
     | (\"[^"]+\")                                                   # String
     | (-?[0-9]+)                                                    # Integer
     | ([A-Z][a-zA-Z0-9]+\.[A-Z][a-zA-Z0-9]+)                        # ExportType
     | ([A-Z][a-zA-Z0-9]+)                                           # Type
     //
    
    read-discrimination = (str)->
      str.split(/\s\|\s/).map(read-body)
    
    invoke-function = (str)->
      str.split(" ")
    
    tokenize-body = (input)->
     return [] if typeof! input isnt \Array
     res = 
      | input.1? => type: \RegularExpression , body: input.0
      | input.2? => type: \Discrimination , body: read-discrimination(input.0)
      | input.3? => type: \InvokeFunction , body: invoke-function input.0
      | input.4? => type: \ArrayType , body: input.0.substr(1, input.0.length - 2)
      | input.5? => type: \OperationWithValue , body: input.0.replace(/\@/ , \this)
      | input.6? => type: \String , body: input.0.substr(1, input.0.length - 2)
      | input.7? => type: \Integer , body: input.0
      | input.8? => type: \ExportType , body: input.0
      | input.9? => type: \Type , body: input.0
      | _ => type: \Error
     res.origin = input.0
     res
    
    read-body = (str)->
       tokenize-body str.match(body-pattern)
    tokenize = (input)->
     return [] if typeof! input isnt \Array
     res = 
      | input.1?  => type: \Comment
      | input.2?  => type: \Function, name: input.3, body: read-body(input.5), params: function-params(input.0)
      | input.6?  => type: \Type, name: input.7, body: read-body(input.8)
      | input.9?  => type: \Field, name: input.10, body: read-body(input.11)
      | input.12? => type: \FieldStart
      | input.13? => type: \TypeExtension , name: input.14
      | input.15? => type: \ComplexType , name: input.15
      | _ => type: \Error
     res.origin = input.0
     [res]
    
    naming = (input)->
      return input if typeof! input isnt \Array
      return [] if input.length is 0
      tail = p.tail input
      (tokenize input.0) ++ (naming tail)
     
    
    read = (input)->
       return read(input.to-string(\utf8)) if typeof! input is \Uint8Array
       return read(input.split(\\n)) if typeof! input is \String 
       return "Reading error: #{typeof! input} is not supported" if typeof! input isnt \Array
       return [] if input.length is 0
       result = 
          | input.0.length is 0 => ""
          | _ => input.0.match(pattern)
       return "Syntax Error: Unexpected Token on '#{input.0}'" if typeof! result is \Null
       next = read p.tail input
       return next if typeof! next is \String 
       return [result] ++ next
          
       
    checkers =
      * curr: \Field 
        after: [\FieldStart, \Field]
        otherwise: "Error: Field can go only after '----' FieldStart or Previous Field"
      * curr: \FieldStart
        after: [\ComplexType]
        otherwise: "Error: FieldStart '----' can go only after ComplexType declaration statement"
      * curr: \Function
        after: [\Function, \TypeExtension] 
        otherwise: "Error: Function '----' can go only after Type... extension or Previous Function"
    
    parse = (registry, lines)-->
     return lines if typeof! lines isnt \Array
     return registry if lines.length is 0
     curr = lines.0
     return curr if typeof! curr is \String
     last = registry[registry.length - 1] ? {} 
     for checker in checkers 
      if checker.curr is curr.type and checker.after.index-of(last.type) is -1
        registry.push(checker.otherwise)
        return registry
     switch curr.type  
      case \ComplexType
       curr.fields = []
       #curr.type = \FieldStart
       registry.push curr
      case \FieldStart
       last.type = \FieldStart
      case \Field
       last.fields.push curr
      case \TypeExtension
       curr.functions = [] 
       registry.push curr
      case \Function
       last.functions.push curr
      
      case \Type
       registry.push curr
      
      return parse registry, p.tail(lines)
      
    beautify = (items)->
      return items if typeof! items isnt \Array
      types = {}
      register = (item)->
        get-type = ->
          types[item.name] = types[item.name] ? {}
        switch item.type
         case \Type
          type = get-type!
          type.type = item.body.type
          type.body = item.body.body
          
         case \TypeExtension
          type = get-type!
          type.extensions = item.functions
         case \FieldStart
          type = get-type!
          type.type = \Complex
          type.fields = item.fields
      items.for-each register
      types
    compile = (example)->
     example |> read 
             |> naming
             |> parse []
             |> beautify
    transform-value-field = (field)->
       type: \Field
       name: field.0
       body: transform-value field.1

    transform-value-fields = (fields)->
       fields |> map transform-obj-field

    transform-value = (o)->
       switch typeof! o
          case \Object
              return type: \Complex, fields: transform-value-fields obj-to-pairs o
          case \String
              return type: \RegexExpression, body: o
          case \Number
              return type: \Global.Number, body: o
          case \Boolean
              return type: \Global.Boolean, body: o
          case \Function
              return type: \Global.Function, body: o
          case \Undefined
              return type: \Global.Undefined, body: o
          case \Null
              return type: \Global.Null, body: o
          else 
              return type: \Global.Unknown, body: o
    compare = (type, transformed)->
        ""
    materialize-type = (type)->
        type
    registry = {}
    validate = (value, key)->
        pair = key.split(\.)
        type = registry[pair.0]?[pair.1]
        return "Type #{key} is not Declared" if not type?
        materialized = 
          materialize-type value
        transformed =
          transform-value value
        compare materialized, transformed
    register = (name, code)->
        registry[name] = compile code
    
    validate: validate
    register: register
    compile: compile
    
    
