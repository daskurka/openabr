View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.dataField

  bindings:
    'model.name': '[data-hook~=name]'
    'model.type': '[data-hook~=type]'
    'model.dbName': '[data-hook~=dbName]'
    'model.required': '[data-hook~=required]'
    'researcher': '[data-hook~=creator]'
    'model.description': '[data-hook~=description]'

  derived:
    researcher:
      deps: ['model.creator']
      fn: () -> return app.lookup.user(@.model.creator).name

  events:
    'click [data-hook~=field-row]': 'handleDataFieldRowClick'

  handleDataFieldRowClick: () ->
    app.navigate(@.model.editUrl)