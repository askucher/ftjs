fs = require \fs
chai = require \chai
expect = chai.expect
validator = require \../lib/validator.js

system = fs.read-file-sync __dirname + \/../examples/system.ft .to-string \utf8

validate = validator system 

describe \basic, (...)->
  it 'String Test', (...)->
    expect(validate("String", "Some Custom String")).to.equal(yes)
    expect(validate("String", 1)).to.not.equal(yes)
  
  it 'Integer Test', (...)->
    expect(validate("Integer", 1)).to.equal(yes)
    expect(validate("Integer", "1")).to.not.equal(yes)
  
  it 'Int Test', (...)->
    expect(validate("Int", 10)).to.equal(yes)
    expect(validate("Int", null)).to.not.equal(yes)
    
  it 'Double Test', (...)->
    expect(validate("Double", 10.0)).to.equal(yes)
    expect(validate("Double", null)).to.not.equal(yes)
    
  it 'Numeric Test', (...)->
    expect(validate("Numeric", 10.0)).to.equal(yes)
    expect(validate("Numeric", "10.0")).to.not.equal(yes)
  
  it 'Boolean Test (True)', (...)->
    expect(validate("Boolean", true)).to.equal(yes)
    expect(validate("Boolean", false)).to.equal(yes)
    expect(validate("Bool", false)).to.equal(yes)
    expect(validate("Boolean", 5)).to.not.equal(yes)
    
  it 'Null Test', (...)->
    expect(validate("Null", null)).to.equal(yes)
    expect(validate("Null", "")).to.not.equal(yes)
    
  it 'Undefined Test', (...)->
    expect(validate("Undefined", undefined)).to.equal(yes)
    expect(validate("Undefined", null)).to.not.equal(yes)
    expect(validate("Undefined", 1)).to.not.equal(yes)

  it 'Email Test', (...)->
    expect(validate("Email", "test@gmail.com")).to.equal(yes)
    expect(validate("Email", "test@gmail")).to.not.equal(yes)
    
  it 'Status Test', (...)->
    expect(validate("Status", "active")).to.equal(yes)
    expect(validate("Status", "inactive")).to.equal(yes)
    expect(validate("Status", "invalid")).to.not.equal(yes)
    
  it 'Missing Test', (...)->
    expect(validate("Missing", undefined)).to.equal(yes)
    expect(validate("Missing", null)).to.equal(yes)
    expect(validate("Missing", "invalid")).to.not.equal(yes)

  it 'Object Test', (...)->
    user = 
      email          : \a.stegno@gmail.com
      picture        : \http://some
      firstname      : \Andrey
      lastname       : \Test
      status         : \active
      bio            : \Ho
      tags           : [\user]
    expect(validate("User", user)).to.equal(yes)