InputView = require 'ampersand-input-view'
templates = require '../../templates'

dbNameExists = (value, originalValue, collectionName, callback) ->
  #ignore match original value for when editing
  if value is originalValue then return callback(no)

  #build our server hit
  url = '/api/data-fields/check'
  data = {dbName : value, colName: collectionName}
  $.get(url, data).done (response) ->
    callback(response.exists)

module.exports = InputView.extend
  template: templates.includes.form.input

  initialize: (spec) ->
    InputView.prototype.initialize.apply(@, arguments)
    @.collectionName = spec.colName

  #my override of default behavoir to allow checking for duplcate field codes
  handleInputChanged: () ->
    if (document.activeElement is @.input) then @.directlyEdited = yes
    @.inputValue = @.clean(@.input.value)
    dbNameExists @.inputValue, @.startingValue, @.collectionName, (fieldAlreadyExists) =>
      if fieldAlreadyExists
        @.shouldValidate = yes
        @.message = "Sorry, that field code is already taken. Please try another or use the existing field."