FormView = require 'ampersand-form-view'
PageView = require '../base.coffee'
templates = require '../../templates'

FieldModel = require '../../models/field-model.coffee'
FieldCollection = require '../../collections/field-collection.coffee'

DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

SubjectModel = require '../../models/core/subject.coffee'

InputView = require '../../forms/controls/input.coffee'
NumberView = require '../../forms/controls/number.coffee'

module.exports = PageView.extend

  pageTitle: 'Subject Detail'
  template: templates.pages.subjects.detail

  props:
    fieldViews: 'array'
    fixedFieldNames: 'array'
    userFieldNames: 'array'

  subviews:
    form:
      hook: 'subject-form'
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
              if @.model[field] isnt data[field]
                @.model[field] = data[field]

            for field in @.userFieldNames
              if @.model.fields[field] isnt data[field]
                @.model.fields[field] = data[field]

            @.model.save null,
              success: (model, response, options) ->
                app.navigate("subjects")

  events:
    'click [data-hook="cancel"]': 'cancel'

  cancel: () ->
    app.navigate('subjects')

  initialize: (spec) ->
    dataFields = new DataFieldsCollection()
    dataFields.loadFields 'subject', () =>
      fixedFields = new FixedDataFieldsCollection()
      fixedFields.addFixedFields 'subject'

      subject = new SubjectModel(id: spec.id)
      subject.fetch
        success: (model, response, options) =>
          @.model = model

          fieldViews = []
          fixedFieldNames = []
          userFieldNames = []
          fixedFields.forEach (field) ->
            if field.autoPop then return
            addView(fieldViews, field.type, field.name, field.dbName, field.required, field.config, model.get(field.dbName))
            fixedFieldNames.push field.dbName
          dataFields.forEach (field) ->
            addView(fieldViews, field.type, field.name, field.dbName, field.required, field.config, model.get('fields')[field.dbName])
            userFieldNames.push field.dbName

          @.fixedFieldNames = fixedFieldNames
          @.userFieldNames = userFieldNames
          @.fieldViews = fieldViews #this triggers form render


  addView = (fieldViews, type, name, dbName, required, config, value) ->
    switch type
      when 'string'
        fieldViews.push new InputView
          label: name
          name: dbName
          value: value
          placeholder: name
          required: required
      when 'number'
        fieldViews.push new NumberView
          label: name
          name: dbName
          value: value
          placeholder: name
          required: required
          prefix: config.prefix
          unit: config.unit
          type: 'number'
      when 'date'
        fieldViews.push new InputView
          label: name
          name: dbName
          value: value.toISOString().split('T')[0]
          placeholder: name
          required: required
          type: 'date'