FormView = require 'ampersand-form-view'
InputView = require './controls/input.coffee'
PasswordView = require './controls/password.coffee'

module.exports = FormView.extend

  fields: () ->
    return [
      new PasswordView
        label: 'Current Password'
        name: 'old'
    ,
      new PasswordView
        label: 'New Password'
        name: 'new'
    ]