#FT.js
Runtime Type Check System For Javascript

![Flyber](http://res.cloudinary.com/nixar-work/image/upload/v1473975258/13268115_880281065449309_626424912755329334_o.jpg)

  [![NPM Version][npm-image]][npm-url]
  [![Linux Build][travis-image]][travis-url]
  [![Windows Build][appveyor-image]][appveyor-url]
  [![Test Coverage][coveralls-image]][coveralls-url]

Install
```bash
npm install ftjs
```

Type Definition Example ('./examples/System.ft')
```ocaml
#SimpleTypes

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

#TypeExtensions

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


#ComplexTypes

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
   
   var types = require("ftjs");
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



[npm-image]: https://img.shields.io/npm/v/express.svg
[npm-url]: https://npmjs.org/package/flyber-types
[downloads-image]: https://img.shields.io/npm/dm/express.svg
[downloads-url]: https://npmjs.org/package/flyber-types
[travis-image]: https://img.shields.io/travis/expressjs/express/master.svg?label=linux
[travis-url]: https://travis-ci.org/expressjs/express
[appveyor-image]: https://img.shields.io/appveyor/ci/dougwilson/express/master.svg?label=windows
[appveyor-url]: https://ci.appveyor.com/project/dougwilson/express
[coveralls-image]: https://img.shields.io/coveralls/expressjs/express/master.svg
[coveralls-url]: https://coveralls.io/r/expressjs/express?branch=master
[gratipay-image-visionmedia]: https://img.shields.io/gratipay/visionmedia.svg
[gratipay-url-visionmedia]: https://gratipay.com/visionmedia/
[gratipay-image-dougwilson]: https://img.shields.io/gratipay/dougwilson.svg
[gratipay-url-dougwilson]: https://gratipay.com/dougwilson/
