FormView = require 'ampersand-form-view'
InputView = require './controls/input.coffee'
PasswordView = require './controls/password.coffee'

module.exports = FormView.extend

  fields: () ->
    return [
      new InputView
        label: 'Name'
        name: 'name'
        value: @.model and @.model.name
        placeholder: "User's name"
        parent: @
        tests: [
          (val) -> if val.length < 6 then return "Name must be at least 6 characters long."
        ]
    ,
      new InputView
        label: 'Email'
        name: 'email'
        value: @.model and @.model.email
        placeholder: "User's email and username"
        parent: @
        tests: [
          (val) -> if not val.match(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/) then return "Must be a valid email address."
        ]
    ,
      new InputView
        label: 'Position'
        name: 'position'
        value: @.model and @.model.position
        placeholder: "User's position"
        parent: @
    ]