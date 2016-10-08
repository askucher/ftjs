#Simple Types

String         : /.?/

Integer        : Global.Integer

Int            : Integer

Boolean        : Global.Boolean

Bool           : Boolean

Double         : Global.Double

Numeric        : Double | Integer

Null           : Global.Null

Undefined      : Global.Undefined

Email          : /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i

#Type Extensions

String...
Min min        : /^.{#{min},}$/
Max max        : /^.{,#{max}}$/
Range min max  : /^.{#{min},#{max}}$/

Integer...
Min min        : @ >= min
Max max        : @ <= max


#Enums

Status         : "active" | "inactive"

Missing        : Null | Undefined


#Complex Types

User
------------
email          : Email
picture        : String
firstname      : String Range(5,20)
lastname       : String Min(5) Max(20)
status         : Status
bio            : String | Missing
tags           : [String]