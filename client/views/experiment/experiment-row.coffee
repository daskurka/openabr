View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.views.experiments.experimentRow

  props:
    subjects: 'number'
    abrs: 'number'

  initialize: () ->
    #load subject count
    subjectUrl = '/api/subjects/count'
    abrUrl = '/api/abr/readings/count'
    query = {experiments: @.model.id}
    $.get subjectUrl, query, (response) =>
      @.subjects = response.found
      @.queryByHook('subjects').innerHTML = response.found
    $.get abrUrl, query, (response) =>
      @.abrs = response.found
      @.queryByHook('abrs').innerHTML = response.found

  derived:
    researcher:
      deps: ['model.creator']
      fn: () -> return app.lookup.user(@.model.creator).name

  bindings:
    'model.name': '[data-hook~=name]'
    'model.description': '[data-hook~=description]'
    'researcher': '[data-hook~=researcher]'

  events:
    'click [data-hook~=experiment-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.viewUrl)