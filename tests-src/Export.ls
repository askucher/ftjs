fs = require \fs
chai = require \chai
expect = chai.expect
validator = require \../lib/validator.js


validate = validator do
     System: fs.read-file-sync __dirname + \/../examples/System.ft
     Export: fs.read-file-sync __dirname + \/../examples/Export.ft



describe \Export, (...)->
  
  it 'Modules Test', (...)->
    expect(validate.registry.System).to.have.property('String')
    expect(validate.registry.Export).to.have.property('String')
  
  it 'Export Integer Test', (...)->
    expect(validate("Export.Integer", 1)).to.equal(yes)
    expect(validate("Export.Integer", "1")).to.not.equal(yes)
  
  it 'Export String Test', (...)->
    expect(validate("Export.String", "1")).to.equal(yes)
    expect(validate("Export.String", 1)).to.not.equal(yes)
  
    