View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.account

  bindings:
    'model.name': '[data-hook~=name]'
    'model.address': '[data-hook~=address]'
    'model.users':
      type: (el, value, lastValue) ->
        el.innerText = "#{value.length} Users"
      hook: 'users'
    'model.admins':
      type: (el, value, lastValue) ->
        el.innerText = "#{value.length} Admins"
      hook: 'admins'

  events:
    'click [data-hook~=account-row]': 'handleAccountRowClick'

  handleAccountRowClick: () ->
    app.navigate(@.model.editUrl)