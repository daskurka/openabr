InputView = require 'ampersand-input-view'
templates = require '../../templates'

module.exports = InputView.extend
  template: templates.includes.form.input

  initialize: (spec) ->
    InputView.prototype.initialize.apply(@, arguments)
    @.parent.on 'change:type', (event) =>
      if event.value is 'number'
        $(@.el).show()
      else
        $(@.el).hide()