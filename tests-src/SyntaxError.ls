
fs = require \fs
chai = require \chai
expect = chai.expect
validator = require \../lib/validator.js


validate = validator do
     SyntaxError: fs.read-file-sync __dirname + \/../examples/SyntaxError.ft



describe \SyntaxError, (...)->
  
  it 'Export Integer Test', (...)->
    expect(validate("SyntaxError.Integer", 1)).to.equal("Syntax Error: Unexpected Token on 'Integer     = Global.Number'")
  
  
    