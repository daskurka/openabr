View = require 'ampersand-view'

module.exports = View.extend

  template: "<tr data-hook='user-row'>
              <td data-hook='title'></td>
              <td data-hook='email'></td>
              <td data-hook='roles'></td>
            </tr>"

  bindings:
    'model.title': '[data-hook=title]'
    'model.name': '[data-hook=email]'
    'model.couchRoles': '[data-hook=roles]'

  events:
    'click [data-hook~=user-row]': 'editUser'

  editUser: () ->
    App.navigate "/users/#{@.model.name}"
