InputView = require 'ampersand-input-view'
templates = require '../../templates'

emailExists = (value, originalValue, callback) ->
  #ignore match original value for when editing
  if value is originalValue then return callback(no)

  #build our server hit
  url = '/api/admin/users/check'
  data = {email : value}
  $.get(url, data).done (response) ->
    callback(response.exists)

module.exports = InputView.extend
  template: templates.includes.form.input

  #my override of default behavoir to allow checking for duplcate email addresses
  handleInputChanged: () ->
    if (document.activeElement is @.input) then @.directlyEdited = yes
    @.inputValue = @.clean(@.input.value)
    emailExists @.inputValue, @.startingValue, (emailAlreadyExists) =>
      if emailAlreadyExists
        @.shouldValidate = yes
        @.message = "Sorry, that email address is already taken. Please try another or editing the existing user account."


