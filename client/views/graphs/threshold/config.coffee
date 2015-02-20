View = require 'ampersand-view'
templates = require '../../../templates'

module.exports = View.extend

  template: templates.views.graphs.threshold.config

  bindings:
    'model.mode': '[data-hook~=mode]'
    'model.groupBy':
      type: 'value'
      hook: 'group-by'
    'groupable':
      type: 'toggle'
      selector: '#groupBySection'

  derived:
    groupable:
      deps: ['model.groupBy']
      fn: () -> if @.model.groupBy is 'N-A' then no else yes

  events:
    'change [data-hook~=group-by]': 'groupByChanged'

  groupByChanged: (event) ->
    @.model.groupBy = event.target.value