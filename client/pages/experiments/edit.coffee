FormView = require 'ampersand-form-view'
PageView = require '../base.coffee'
templates = require '../../templates'

FieldModel = require '../../models/field-model.coffee'
FieldCollection = require '../../collections/field-collection.coffee'

DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

ExperimentModel = require '../../models/core/experiment.coffee'

InputView = require '../../forms/controls/input.coffee'
NumberView = require '../../forms/controls/number.coffee'

module.exports = PageView.extend

  pageTitle: 'Edit Experiment'
  template: templates.pages.experiments.edit

  props:
    fieldViews: 'array'
    fixedFieldNames: 'array'
    userFieldNames: 'array'
    availableFields: 'object'

  subviews:
    form:
      hook: 'experiment-form'
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

            if not @.model.fields? then @.model.fields = {}
            for field in @.userFieldNames
              if @.model.fields[field] isnt data[field] or not @.model.fields[field]?
                @.model.fields[field] = data[field]

            @.model.save null,
              success: (model, response, options) ->
                app.navigate("experiments")

  events:
    'click [data-hook="cancel"]': 'cancel'
    'click [data-hook="field-option"]': 'addField'

  cancel: () ->
    app.navigate('experiments')

  initialize: (spec) ->
    dataFields = new DataFieldsCollection()
    dataFields.loadFields 'experiment', () =>
      fixedFields = new FixedDataFieldsCollection()
      fixedFields.addFixedFields 'experiment'

      experiment = new ExperimentModel(id: spec.id)
      experiment.fetch
        success: (model, response, options) =>
          @.model = model

          @.availableFields = {}
          fieldViews = []
          fixedFieldNames = []
          userFieldNames = []
          fixedFields.forEach (field) ->
            if field.autoPop then return
            view = buildView(field.type, field.name, field.dbName, field.required, field.config, model.get(field.dbName))
            if view isnt null then fieldViews.push view
            fixedFieldNames.push field.dbName
          if model.fields?
            dataFields.forEach (field) =>
              if model.fields[field.dbName]? or field.required
                view = buildView(field.type, field.name, field.dbName, field.required, field.config, model.get('fields')[field.dbName])
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

  buildView = (type, name, dbName, required, config, value) ->
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
          value: value
          placeholder: name
          required: required
          prefix: config.prefix
          unit: config.unit
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