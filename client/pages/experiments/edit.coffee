Base = require '../edit-base.coffee'
templates = require '../../templates'

ExperimentModel = require '../../models/core/experiment.coffee'

module.exports = Base.extend

  pageTitle: 'Edit Experiment'
  template: templates.pages.experiments.edit

  initialize: (spec) ->
    experiment = new ExperimentModel(id: spec.id)
    experiment.fetch
      success: (model) =>
        @.loadFieldsAndModel('experiment', model)

  afterSave: () ->
    app.navigate(@.model.viewUrl)

  cancel: () ->
    app.navigate(@.model.viewUrl)

