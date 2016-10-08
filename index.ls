fs = require \fs
typedef = fs.read-file-sync './types/system.hs' .to-string \utf8
validator = require \./validator.js
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