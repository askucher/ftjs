// Generated by LiveScript 1.5.0
var fs, chai, expect, validator, system, validate;
fs = require('fs');
chai = require('chai');
expect = chai.expect;
validator = require('../lib/validator.js');
system = fs.readFileSync(__dirname + '/../examples/system.ft').toString('utf8');
validate = validator(system);
describe('basic', function(){
  it('String Test', function(){
    expect(validate("String", "Some Custom String")).to.equal(true);
    return expect(validate("String", 1)).to.not.equal(true);
  });
  it('Integer Test', function(){
    expect(validate("Integer", 1)).to.equal(true);
    return expect(validate("Integer", "1")).to.not.equal(true);
  });
  it('Int Test', function(){
    expect(validate("Int", 10)).to.equal(true);
    return expect(validate("Int", null)).to.not.equal(true);
  });
  it('Double Test', function(){
    expect(validate("Double", 10.0)).to.equal(true);
    return expect(validate("Double", null)).to.not.equal(true);
  });
  it('Numeric Test', function(){
    expect(validate("Numeric", 10.0)).to.equal(true);
    return expect(validate("Numeric", "10.0")).to.not.equal(true);
  });
  it('Boolean Test (True)', function(){
    expect(validate("Boolean", true)).to.equal(true);
    expect(validate("Boolean", false)).to.equal(true);
    expect(validate("Bool", false)).to.equal(true);
    return expect(validate("Boolean", 5)).to.not.equal(true);
  });
  it('Null Test', function(){
    expect(validate("Null", null)).to.equal(true);
    return expect(validate("Null", "")).to.not.equal(true);
  });
  it('Undefined Test', function(){
    expect(validate("Undefined", undefined)).to.equal(true);
    expect(validate("Undefined", null)).to.not.equal(true);
    return expect(validate("Undefined", 1)).to.not.equal(true);
  });
  it('Email Test', function(){
    expect(validate("Email", "test@gmail.com")).to.equal(true);
    return expect(validate("Email", "test@gmail")).to.not.equal(true);
  });
  it('Status Test', function(){
    expect(validate("Status", "active")).to.equal(true);
    expect(validate("Status", "inactive")).to.equal(true);
    return expect(validate("Status", "invalid")).to.not.equal(true);
  });
  it('Missing Test', function(){
    expect(validate("Missing", undefined)).to.equal(true);
    expect(validate("Missing", null)).to.equal(true);
    return expect(validate("Missing", "invalid")).to.not.equal(true);
  });
  return it('Object Test', function(){
    var user;
    user = {
      email: 'a.stegno@gmail.com',
      picture: 'http://some',
      firstname: 'Andrey',
      lastname: 'Test',
      status: 'active',
      bio: 'Ho',
      tags: ['user']
    };
    return expect(validate("User", user)).to.equal(true);
  });
});