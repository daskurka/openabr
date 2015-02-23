Base = require '../edit-base.coffee'
templates = require '../../templates'

AbrSetModel = require '../../models/core/abr-set.coffee'

module.exports = Base.extend

  pageTitle: 'Edit ABR Set'
  template: templates.pages.abrSets.edit

  initialize: (spec) ->
    abrSet = new AbrSetModel(id: spec.id)
    abrSet.fetch
      success: (model) =>
        @.loadFieldsAndModel('abr-set', model)

  afterSave: () ->
    app.navigate(@.model.viewUrl)

  cancel: () ->
    app.navigate(@.model.viewUrl)