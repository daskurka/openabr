FormView = require 'ampersand-form-view'
PageView = require './base.coffee'

FieldModel = require '../models/field-model.coffee'
FieldCollection = require '../collections/field-collection.coffee'

DataFieldsCollection = require '../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../collections/core/fixed-data-fields.coffee'

InputView = require '../forms/controls/input.coffee'
NumberView = require '../forms/controls/number.coffee'
StaticInputView = require '../forms/controls/static-input.coffee'
StaticNumberView = require '../forms/controls/static-number.coffee'

module.exports = PageView.extend

  #add
  #pageTitle: 'Edit xxxxxx'
  #template: templates.pages.xxxxx

  #template hook should be 'edit-form'

  #override afterSave with after save handling code
  #override cancel with cancel handling code

  #call loadFieldsAndModel initialize with model and name of fields

  props:
    fieldViews: 'array'
    fixedFieldNames: 'array'
    userFieldNames: 'array'
    availableFields: 'object'

  subviews:
    form:
      hook: 'edit-form'
      waitFor: 'fieldViews'
      prepareView: (el) ->
        return new FormView
          el: el
          model: @.model
          fields: @.fieldViews
          submitCallback: (data) =>
            for name of data
              if data[name] is '' then data[name] = null

            for field in @.fixedFieldNames
              if not field of data or data[field] is null
                @.model[field] = null
              else if @.model[field] isnt data[field]
                @.model[field] = data[field]

            if not @.model.fields? then @.model.fields = {}
            for field in @.userFieldNames
              if not field of data or data[field] is null
                delete @.model.fields[field]
              else if @.model.fields[field] isnt data[field] or not @.model.fields[field]?
                @.model.fields[field] = data[field]

            @.model.save null,
              success: (model, response, options) => do @.afterSave

  afterSave: () ->
    console.log 'after save should be overridden to work...'

  events:
    'click [data-hook="cancel"]': 'cancel'
    'click [data-hook="field-option"]': 'addField'

  cancel: () ->
    console.log 'cancel should be overridden to work...'

  loadFieldsAndModel: (name, model) ->
    dataFields = new DataFieldsCollection()
    dataFields.loadFields name, () =>
      fixedFields = new FixedDataFieldsCollection()
      fixedFields.addFixedFields name

      @.model = model

      @.availableFields = {}
      fieldViews = []
      fixedFieldNames = []
      userFieldNames = []
      fixedFields.forEach (field) ->
        if field.autoPop then return
        view = buildView(field.type, field.name, field.dbName, field.required, field.config, model.get(field.dbName), field.autoPop)
        if view isnt null then fieldViews.push view
        fixedFieldNames.push field.dbName
      if model.fields?
        dataFields.forEach (field) =>
          if model.fields[field.dbName]? or field.required
            view = buildView(field.type, field.name, field.dbName, field.required, field.config, model.get('fields')[field.dbName], field.autoPop)
            if view isnt null then fieldViews.push view
            userFieldNames.push field.dbName
          else
            @.availableFields[field.dbName] = field
      else
        dataFields.forEach (field) => @.availableFields[field.dbName] = field

      @.fixedFieldNames = fixedFieldNames
      @.userFieldNames = userFieldNames
      @.fieldViews = fieldViews #this triggers form render

      do @.renderFieldOptions

  renderFieldOptions: () ->
    html = ''
    for field of @.availableFields
      obj = @.availableFields[field]
      html += "<button type='button' data-hook='field-option' class='btn btn-default' data='#{obj.dbName}'>#{obj.name}</span>"
    $('#fieldArea').html(html)

  addField: (event) ->
    dbName = event.target.attributes['data'].value
    field = @.availableFields[dbName]
    view = buildView(field.type, field.name, field.dbName, field.required, field.config)
    @._subviews[0].addField(view)
    delete @.availableFields[dbName]
    @.userFieldNames.push dbName
    do @.renderFieldOptions

  buildView = (type, name, dbName, required, config, value, autoPop) ->
    if config is null then config = {}
    if autoPop
      switch type
        when 'string'
          return new StaticInputView
            label: name
            name: dbName
            value: value
        when 'number'
          return new StaticNumberView
            label: name
            name: dbName
            value: parseFloat(value)
            prefix: config.prefix ? ''
            unit: config.unit ? ''
        when 'date'
          return new StaticInputView
            label: name
            name: dbName
            value: value and value.toISOString().split('T')[0]
        else
          return null
    else
      switch type
        when 'string'
          return new InputView
            label: name
            name: dbName
            value: value
            placeholder: name
            required: required
        when 'number'
          return new NumberView
            label: name
            name: dbName
            value: parseFloat(value)
            placeholder: name
            required: no #all numbers must not be required else you cant use zero :|
            prefix: config.prefix ? ''
            unit: config.unit ? ''
            type: 'number'
        when 'date'
          return new InputView
            label: name
            name: dbName
            value: value and value.toISOString().split('T')[0]
            placeholder: name
            required: required
            type: 'date'
        else
          return null