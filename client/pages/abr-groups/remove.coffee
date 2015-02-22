PageView = require '../base.coffee'
templates = require '../../templates'
_ = require 'lodash'

Model = require '../../models/core/abr-group.coffee'

module.exports = PageView.extend

  pageTitle: 'Remove ABR Group'
  template: templates.pages.abrGroups.remove

  initialize: (spec) ->
    model = new Model(id: spec.id)
    model.fetch
      success: (model) =>
        model.lazyLoadSets () =>
          model.sets.each (set) =>
            set.lazyLoadReadings () =>
              @.model = model

  bindings:
    'model.name': '[data-hook~=subtitle]'

  events:
    'click [data-hook~=remove]': 'removeModel'
    'click [data-hook~=cancel]': 'cancel'

  removeModel: () ->
    @.model.sets.each (set) ->
      set.readings.each (reading) ->
        reading.destroy
      set.destroy

    #subject
    @.model.destroy
      success: () ->
        app.navigate('')

  cancel: () ->
    app.navigate(@.model.viewUrl)