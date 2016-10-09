#Flyber Types
Runtime Type Check System For Javascript

  [![NPM Version][npm-image]][npm-url]
  [![NPM Downloads][downloads-image]][downloads-url]
  [![Linux Build][travis-image]][travis-url]
  [![Windows Build][appveyor-image]][appveyor-url]
  [![Test Coverage][coveralls-image]][coveralls-url]

Install
```bash
npm install flyber-types
```

Type Definition Example ('./examples/System.ft')
```javascript
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

Strings        : [String]

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
```

Use 
```javascript
   
   var types = require("flyber-types");
   var fs = require("fs");
   
   var validate = types({
      System: fs.readFileSync("./examples/System.ft").toString("utf8")
   });
   
   var user = {
      email: 'a.stegno@gmail.com',
      picture: 'http://some-website.com/picture.png',
      firstname: 'Andrey',
      lastname: 'Test',
      status: 'active',
      bio: 'Ho',
      tags: ["user"]
   };
   
   validate("System.User", user); //true
```

![Flyber](http://res.cloudinary.com/nixar-work/image/upload/v1473975258/13268115_880281065449309_626424912755329334_o.jpg)
