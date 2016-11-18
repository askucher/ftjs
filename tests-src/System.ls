fs = require \fs
chai = require \chai
expect = chai.expect
validator = require \../lib/validator.js

validate = validator do
     System: fs.read-file-sync __dirname + \/../examples/System.ft .to-string \utf8


describe \System, (...)->
  
  it 'Type Not Exists Test', (...)->
    expect(validate("TypeNotExists", "Some Custom String")).to.not.equal(yes)
  
  it 'String Test', (...)->
    expect(validate("System.String", "Some Custom String")).to.equal(yes)
    expect(validate("System.String", 1)).to.not.equal(yes)
  
  it 'Integer Test', (...)->
    expect(validate("System.Integer", 1)).to.equal(yes)
    expect(validate("System.Integer", "1")).to.not.equal(yes)
  
  it 'Int Test', (...)->
    expect(validate("System.Int", 10)).to.equal(yes)
    expect(validate("System.Int", null)).to.not.equal(yes)
    
  it 'Double Test', (...)->
    expect(validate("System.Double", 10.0)).to.equal(yes)
    expect(validate("System.Double", null)).to.not.equal(yes)
    
  it 'Numeric Test', (...)->
    expect(validate("System.Numeric", 10.0)).to.equal(yes)
    expect(validate("System.Numeric", "10.0")).to.not.equal(yes)
  
  it 'Boolean Test (True)', (...)->
    expect(validate("System.Boolean", true)).to.equal(yes)
    expect(validate("System.Boolean", false)).to.equal(yes)
    expect(validate("System.Bool", false)).to.equal(yes)
    expect(validate("System.Boolean", 5)).to.not.equal(yes)
    
  it 'Null Test', (...)->
    expect(validate("System.Null", null)).to.equal(yes)
    expect(validate("System.Null", "")).to.not.equal(yes)
    
  it 'Undefined Test', (...)->
    expect(validate("System.Undefined", undefined)).to.equal(yes)
    expect(validate("System.Undefined", null)).to.not.equal(yes)
    expect(validate("System.Undefined", 1)).to.not.equal(yes)

  it 'Email Test', (...)->
    expect(validate("System.Email", "test@gmail.com")).to.equal(yes)
    expect(validate("System.Email", "test@gmail")).to.not.equal(yes)
    
  it 'Status Test', (...)->
    expect(validate("System.Status", "active")).to.equal(yes)
    expect(validate("System.Status", "inactive")).to.equal(yes)
    expect(validate("System.Status", "invalid")).to.not.equal(yes)
    
  it 'Missing Test', (...)->
    expect(validate("System.Missing", undefined)).to.equal(yes)
    expect(validate("System.Missing", null)).to.equal(yes)
    expect(validate("System.Missing", "invalid")).to.not.equal(yes)
    
  it 'Array of String Test', (...)->
    expect(validate("System.Strings", ["test"])).to.equal(yes)
    expect(validate("System.Strings", ["test", "test"])).to.equal(yes)
    expect(validate("System.Strings", "invalid")).to.not.equal(yes)
    expect(validate("System.Strings", ["test", "test", 1])).to.not.equal(yes)

  it 'Object Test', (...)->
    user = 
      _id:           : "Identity"
      email          : \a.stegno@gmail.com
      picture        : \http://some
      firstname      : \Andrey
      lastname       : \Jobs
      status         : \active
      bio            : \Ho
      age            : 19
      tags           : [\user]
    expect(validate("System.User", user)).to.equal(yes)
    
    wrong-user = 
      email          : \a.stegno@gmail.com
      picture        : \http://some
      firstname      : \Andrey
      lastname       : \Jobs
      status         : \active
      bio            : \Ho
      age            : 15
      tags           : [\user]
    expect(validate("System.User", wrong-user)).to.not.equal(yes)