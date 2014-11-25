PageView = require './base.coffee'
templates = require '../templates'

module.exports = PageView.extend

  pageTitle: 'Login'
  template: templates.pages.login

  events:
    'submit .form-signin': 'submit'

  submit: (event) ->
    do event.preventDefault

    email = $('#emailAddress').val()
    pass = $('#password').val()
    rmbr = $('#rememberMe').is(':checked')

    app.login email, pass, rmbr, (err, correct) ->
      if err? then return console.log "Error logging in: #{err}"
      if not correct
        $('#failedLoginAlert').removeClass('hidden')