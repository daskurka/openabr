FormView = require 'ampersand-form-view'
SelectView = require 'ampersand-select-view'
CheckboxView = require 'ampersand-checkbox-view'

InputView = require './controls/input.coffee'
EmailView = require './controls/email.coffee'
DbNameView = require './controls/field-db-name.coffee'
NumberPrefix = require './controls/number-prefix.coffee'
NumberUnit = require './controls/number-unit.coffee'

templates = require '../templates'

module.exports = FormView.extend
  fields: () ->
    return [
      new SelectView
        label: 'Field Type'
        name: 'type'
        template: templates.includes.form.select() #bootstrap friendly
        value: @.model and @.model.type ? 'number'
        options: [
          ['number','Number']
          ['string','Text']
          ['date','Date']
        ]
        required: yes
        parent: @
    ,
      new NumberPrefix
        label: 'Number SI Prefix (Scale kilo, Mega...)'
        name: 'prefix'
        value: @.model and @.model.config and @.model.config.prefix ? ' '
        template: templates.includes.form.select() #bootstrap friendly
        options: [
          ['P','P (peta 10¹⁵)']
          ['T','T (tera 10¹²)']
          ['G','G (giga 10⁹)']
          ['M','M (mega 10⁶)']
          ['k','k (kilo 10³)']
          ['h','h (hecto 10²)']
          ['da','da (deca 10¹)']
          [' ','-']
          ['d','d (deci 10⁻¹)']
          ['c','c (centi 10⁻²)']
          ['m','m (milli 10⁻³)']
          ['μ','μ (micro 10⁻⁶)']
          ['n','n (nano 10⁻⁹)']
          ['p','p (pico 10⁻¹²)']
          ['f','f (femto 10⁻¹⁵)']
        ]
        parent: @
    ,
      new NumberUnit
        label: 'Number Unit (e.g. g or Hz)'
        name: 'unit'
        value: @.model and @.model.config and @.model.config.unit
        required: no
        parent: @
    ,
      new InputView
        label: 'Name'
        name: 'name'
        value: @.model and @.model.name
        placeholder: 'Field name'
        parent: @
        tests: [
          (val) -> if val.length < 6 then return "Name must be at least 6 characters long."
          (val) -> if val.length > 32 then return "Name must be no longer than 32 characters."
        ]
    ,
      new InputView
        label: 'Description'
        name: 'description'
        value: @.model and @.model.description
        placeholder: 'Brief description'
        parent: @
        tests: [
          (val) -> if val.length > 65 then return "Name must be no longer than 65 characters."
        ]
    ,
      new DbNameView
        label: 'Database Code'
        name: 'dbName'
        value: @.model and @.model.dbName
        placeholder: 'Database Field Code'
        parent: @
        colName: @.data.colName
        tests: [
          (val) -> if val.length < 2 then return "Code must be at least 2 characters long."
          (val) -> if val.length > 6 then return "Code must be no longer than 6 characters."
          (val) -> if not val.match(/^[a-zA-Z0-9]+$/) then return "Code must be numbers or letters only."
        ]
    ,
      new CheckboxView
        label: 'Is Compulsory'
        name: 'required'
        template: templates.includes.form.checkbox() #bootstrap friendly
        value: @.model and @.model.required
    ]