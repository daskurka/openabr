Base = require '../edit-base.coffee'
templates = require '../../templates'

AbrReadingModel = require '../../models/core/abr-reading.coffee'

module.exports = Base.extend

  pageTitle: 'Edit ABR Reading'
  template: templates.pages.abrReadings.edit

  initialize: (spec) ->
    abrReading = new AbrReadingModel(id: spec.id)
    abrReading.fetch
      success: (model) =>
        @.loadFieldsAndModel('abr-reading', model)

  afterSave: () ->
    app.navigate(@.model.viewUrl)

  cancel: () ->
    app.navigate(@.model.viewUrl)