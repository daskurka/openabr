FormView = require 'ampersand-form-view'
InputView = require './controls/input.coffee'
UsersView = require './controls/users.coffee'

module.exports = FormView.extend

  fields: () ->
    return [
        new InputView
          label: 'Account Name'
          name: 'name'
          value: @.model and @.model.name
          placeholder: 'Account Name'
          parent: @
          tests: [
            (val) -> if val.length < 6 then return "Name must be at least 6 characters long."
          ]
      ,
        new InputView
          label: 'Url Name'
          name: 'urlName'
          value: @.model and @.model.urlName
          placeholder: 'Url Name'
          parent: @
          tests: [
            (val) -> if val.length < 6 then return "Url name must be at least 6 characters long."
            (val) -> if not val.match(/^[a-zA-Z]+$/) then return "Url name must only contain the characters A-Z and a-z."
          ]
      ,
        new InputView
          label: 'Address'
          name: 'address'
          value: @.model and @.model.address
          placeholder: 'Address'
          parent: @
      ,
        new InputView
          label: 'Contact'
          name: 'contact'
          value: @.model and @.model.contact
          placeholder: 'contact'
          parent: @
      ,
        new InputView
          label: 'Notes'
          name: 'notes'
          value: @.model and @.model.notes
          placeholder: 'Notes'
          parent: @
      ,
        new UsersView
          label: 'Account Users'
          name: 'users'
          value: @.model and @.model.users
          placeholder: 'Select users for account...'
          url: '/api/admin/users'
          parent: @
          required: no
    ,
        new UsersView
          label: 'Account Administrators'
          name: 'admins'
          value: @.model and @.model.admins
          placeholder: 'Select admins for account...'
          url: '/api/admin/users'
          parent: @
    ]