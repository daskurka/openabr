View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.fixedDataField

  bindings:    
    'model.name': '[data-hook~=name]'
    'model.type': '[data-hook~=type]'
    'model.dbName': '[data-hook~=dbName]'
    'model.required': '[data-hook~=required]'
    'model.description': '[data-hook~=description]'

  events:
    'click [data-hook~=user-row]': 'handleUserRowClick'

  handleUserRowClick: () ->
    #app.navigate(@.model.editUrl)