View = require 'ampersand-view'
FormView = require 'ampersand-form-view'
templates = require '../../templates'

FieldModel = require '../../models/field-model.coffee'
FieldCollection = require '../../collections/field-collection.coffee'
DataFieldsCollection = require '../../collections/core/data-fields.coffee'

InputView = require '../../forms/controls/input.coffee'
NumberView = require '../../forms/controls/number.coffee'
StaticInputView = require '../../forms/controls/static-input.coffee'
StaticNumberView = require '../../forms/controls/static-number.coffee'

module.exports = View.extend

  template: templates.views.upload.confirmFormView

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
        @.formView = new FormView
          el: el
          model: @.model
          fields: @.fieldViews
        return @.formView

  events:
    'click [data-hook="field-option"]': 'addField'

  checkFormValid: () ->
    @.formView.beforeSubmit()
    return @.formView.checkValid()

  getFormData: () ->
    return @.formView.getData()

  render: () ->
    @.renderWithTemplate()

    dataFields = new DataFieldsCollection()
    dataFields.loadFieldsForAbrForm () =>

      @.availableFields = {}
      fieldViews = []
      userFieldNames = []
      dataFields.forEach (field) =>
        if not field.required
          @.availableFields[field.dbName] = field
          return

        view = buildView(field.type, field.name, field.dbName, field.required, field.config)
        if view isnt null then fieldViews.push view
        userFieldNames.push field.dbName

      @.userFieldNames = userFieldNames
      @.fieldViews = fieldViews

      @.renderFieldOptions()

    return @

  renderFieldOptions: () ->
    console.log 'hit'
    console.log @.availableFields
    html = ''
    for field of @.availableFields
      obj = @.availableFields[field]
      html += "<button type='button' data-hook='field-option' class='btn btn-default' data='#{obj.dbName}'>#{obj.name}</span>"
    @.query('#fieldArea').innerHTML = html

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