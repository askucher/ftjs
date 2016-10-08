fs = require \fs
validator = require \../lib/validator.js
typedef = fs.read-file-sync __dirname + '/../examples/system.ft' .to-string \utf8

validate = validator typedef 
user = 
  email          : 'a.stegno@gmail.com'
  picture        : 'http://some'
  firstname      : 'Andrey'
  lastname       : 'Test'
  status         : 'active'
  bio            : 'Ho'
  tags           : ["user"]

console.log validate "User", user