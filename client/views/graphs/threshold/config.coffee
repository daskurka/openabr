View = require 'ampersand-view'
templates = require '../../../templates'

module.exports = View.extend

  template: templates.views.graphs.threshold.config

  bindings:
    'model.mode': '[data-hook~=mode]'
    'model.groupBy':
      type: 'value'
      hook: 'group-by'

  events:
    'change [data-hook~=group-by]': 'groupByChanged'

  groupByChanged: (event) ->
    @.model.groupBy = event.target.value