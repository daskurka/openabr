View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.user

  bindings:
    'model.name': '[data-hook~=name]'
    'model.email': '[data-hook~=email]'
    'model.position': '[data-hook~=position]'

  events:
    'click [data-hook~=user-row]': 'handleUserRowClick'

  handleUserRowClick: () ->
    app.navigate(@.model.editUrl)