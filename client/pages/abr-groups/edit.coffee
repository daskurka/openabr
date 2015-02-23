Base = require '../edit-base.coffee'
templates = require '../../templates'

AbrGroupModel = require '../../models/core/abr-group.coffee'

module.exports = Base.extend

  pageTitle: 'Edit ABR Group'
  template: templates.pages.abrGroups.edit

  initialize: (spec) ->
    abrGroup = new AbrGroupModel(id: spec.id)
    abrGroup.fetch
      success: (model) =>
        @.loadFieldsAndModel('abr-group', model)

  afterSave: () ->
    app.navigate(@.model.viewUrl)

  cancel: () ->
    app.navigate(@.model.viewUrl)

