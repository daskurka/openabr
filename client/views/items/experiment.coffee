View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.experiment

  derived:
    subjects:
      deps: ['model.id']
      fn: () ->
        return 'N/A'
    abrs:
      deps: ['model.id']
      fn: () ->
        return 'N/A'
    researcher:
      deps: ['model.creator']
      fn: () -> return app.lookup.user(@.model.creator).name


  bindings:
    'model.name': '[data-hook~=name]'
    'model.description': '[data-hook~=description]'
    'researcher': '[data-hook~=researcher]'
    'subjects': '[data-hook~=subjects]'
    'abrs': '[data-hook~=abrs]'

  events:
    'click [data-hook~=experiment-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.editUrl)