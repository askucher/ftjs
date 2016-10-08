fs = require \fs
chai = require \chai
expect = chai.expect
validator = require \../lib/validator.js

typedef = fs.read-file-sync __dirname + '/../examples/system.ft' .to-string \utf8

validate = validator typedef 


describe \UserModelCheck, (...)->
  it 'Should Return True', (...)->
    user = 
      email          : \a.stegno@gmail.com
      picture        : \http://some
      firstname      : \Andrey
      lastname       : \Test
      status         : \active
      bio            : \Ho
      tags           : [\user]
    expect(validate("User", user)).to.equal(yes)