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

  pageTitle: 'Create Subject'
  template: templates.pages.subjects.create

  props:
    fieldViews: 'array'
    fixedFieldNames: 'array'
    userFieldNames: 'array'
    availableFields: 'object'

  subviews:
    form:
      hook: 'subject-form'
      waitFor: 'fieldViews'
      prepareView: (el) ->
        return new FormView
          el: el
          fields: @.fieldViews
          submitCallback: (data) =>
            for name of data
              if data[name] is '' then data[name] = null

            subject = new SubjectModel
            for field in @.fixedFieldNames
              subject[field] = data[field]
            subject.creator = app.me.user.id
            subject.created = new Date()
            subject.fields = {}
            for field in @.userFieldNames
              subject.fields[field] = data[field]

            subject.save null,
              success: (model, response, options) ->
                app.navigate("subjects/#{model.id}/detail")

  events:
    'click [data-hook="cancel"]': 'cancel'
    'click [data-hook="field-option"]': 'addField'

  cancel: () ->
    app.navigate('subjects')

  initialize: () ->
    dataFields = new DataFieldsCollection()
    dataFields.loadFields 'subject', () =>
      fixedFields = new FixedDataFieldsCollection()
      fixedFields.addFixedFields 'subject'

      @.availableFields = {}
      fieldViews = []
      fixedFieldNames = []
      userFieldNames = []
      fixedFields.forEach (field) ->
        if field.autoPop then return
        view = buildView(field.type, field.name, field.dbName, field.required, field.config)
        if view isnt null then fieldViews.push view
        fixedFieldNames.push field.dbName
      dataFields.forEach (field) =>
        if not field.required
          @.availableFields[field.dbName] = field
          return

        view = buildView(field.type, field.name, field.dbName, field.required, field.config)
        if view isnt null then fieldViews.push view
        userFieldNames.push field.dbName

      @.fixedFieldNames = fixedFieldNames
      @.userFieldNames = userFieldNames
      @.fieldViews = fieldViews

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
    do @.renderFieldOptions


  buildView = (type, name, dbName, required, config) ->
    switch type
      when 'string'
        return new InputView
          label: name
          name: dbName
          value: null
          placeholder: name
          required: required
      when 'number'
        return new NumberView
          label: name
          name: dbName
          value: null
          placeholder: name
          required: required
          prefix: config.prefix
          unit: config.unit
          type: 'number'
      when 'date'
        return new InputView
          label: name
          name: dbName
          value: null
          placeholder: name
          required: required
          type: 'date'
      else
        return null