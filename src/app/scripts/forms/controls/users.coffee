View = require 'ampersand-input-view'
templates = require '../../templates'
select2 = require 'select2'

module.exports = View.extend

  template: templates.includes.form.users

  props:
    url: ['string',true]

  render: () ->
    do @.renderWithTemplate

    config =
      placeholder: @.placeholder
      minimumInputLength: 2
      multiple: true
      ajax:
        url: @.url
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> return {name: {$regex: "#{term}", $options: 'i'} }
        results: (users, page) ->
          results = []
          for user in users
            results.push {id: user.id, text: user.name}
          return {results: results}
        cache: true
      initSelection: (element, callback) ->
        console.log element

    @.input = @.query('input')
    $(@.input).select2(config)
    $(@.input).on 'change', () => @.handleInputChanged()

    do @.handleTypeChange
    do @.initInputBindings

    @.setValue(@.inputValue, not @.required)

    return @

  #override default set value - we must forcefully populate the select2 with data
  setValue: (value, skipValidation) ->
    if not value? or value.length <= 0
      @.input.value = '' #value needs string
      @.inputValue = [] #this can be an array
    else
      @.input.value = value.join(',')
      @.inputValue = value

    if not skipValidation and not @.getErrorMessage()
      @.shouldValidate = yes

  #override default clean behaviour to turn this back into an array of objectIds
  clean: (val) ->
    cleaned = val.trim()
    if cleaned.length <= 0
      return []
    return val.split(',')