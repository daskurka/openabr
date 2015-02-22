PageView = require '../base.coffee'
templates = require '../../templates'
_ = require 'lodash'

Model = require '../../models/core/abr-reading.coffee'

module.exports = PageView.extend

  pageTitle: 'Remove ABR Reading'
  template: templates.pages.abrReadings.remove

  initialize: (spec) ->
    model = new Model(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

  bindings:
    'model.level': '[data-hook~=subtitle]'

  events:
    'click [data-hook~=remove]': 'removeModel'
    'click [data-hook~=cancel]': 'cancel'

  removeModel: () ->
    #subject
    @.model.destroy
      success: () ->
        app.navigate('')

  cancel: () ->
    app.navigate(@.model.viewUrl)