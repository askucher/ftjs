fs = require \fs
chai = require \chai
expect = chai.expect
validator = require \../lib/validator.js

validate = validator do
     System: fs.read-file-sync __dirname + \/../examples/System.ft .to-string \utf8
     Export: fs.read-file-sync __dirname + \/../examples/Export.ft .to-string \utf8

describe \Export, (...)->
  
  it 'Export Integer Test', (...)->
    expect(validate("Export.Integer", 1)).to.equal(yes)
    expect(validate("Export.Integer", "1")).to.not.equal(yes)
  
  it 'Export String Test', (...)->
    expect(validate("Export.String", "1")).to.equal(yes)
    expect(validate("Export.String", 1)).to.not.equal(yes)
  
    