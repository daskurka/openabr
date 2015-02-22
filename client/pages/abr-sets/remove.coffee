PageView = require '../base.coffee'
templates = require '../../templates'
_ = require 'lodash'

Model = require '../../models/core/abr-set.coffee'

module.exports = PageView.extend

  pageTitle: 'Remove ABR Set'
  template: templates.pages.abrSets.remove

  initialize: (spec) ->
    model = new Model(id: spec.id)
    model.fetch
      success: (model) =>
        model.lazyLoadReadings () =>
          @.model = model

  bindings:
    'model.id': '[data-hook~=subtitle]'

  events:
    'click [data-hook~=remove]': 'removeModel'
    'click [data-hook~=cancel]': 'cancel'

  removeModel: () ->
    @.model.readings.each (reading) ->
      reading.destroy

    #subject
    @.model.destroy
      success: () ->
        app.navigate('')

  cancel: () ->
    app.navigate(@.model.viewUrl)