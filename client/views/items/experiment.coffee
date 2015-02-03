View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.experiment

  props:
    subjects: 'number'

  initialize: () ->
    #load subject count
    url = '/api/subjects/count'
    query = {experiments: @.model.id}
    $.get url, query, (response) =>
      @.subjects = response.found
      @.queryByHook('subjects').innerHTML = response.found

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
    app.navigate(@.model.editUrl)