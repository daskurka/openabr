View = require 'ampersand-view'
templates = require '../../../templates'

module.exports = View.extend

  template: templates.views.graphs.latency.config

  bindings:
    'model.mode': '[data-hook~=mode]'
    'model.groupBy': '[data-hook~=group-by]'

  events:
    'change [data-hook~=mode]': 'modeChanged'
    'change [data-hook~=group-by]': 'groupByChanged'

  initialize: () ->
    console.log @.model

  modeChanged: () ->
    console.log @.value

  groupByChanged: () ->
    console.log @.value