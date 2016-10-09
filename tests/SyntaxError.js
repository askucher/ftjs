// Generated by LiveScript 1.5.0
var fs, chai, expect, validator, validate;
fs = require('fs');
chai = require('chai');
expect = chai.expect;
validator = require('../lib/validator.js');
validate = validator({
  SyntaxError: fs.readFileSync(__dirname + '/../examples/SyntaxError.ft')
});
describe('SyntaxError', function(){
  return it('Export Integer Test', function(){
    return expect(validate("SyntaxError.Integer", 1)).to.equal("Syntax Error: Unexpected Token on 'Integer     = Global.Number'");
  });
});