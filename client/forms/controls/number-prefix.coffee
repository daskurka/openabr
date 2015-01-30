
SelectView = require 'ampersand-select-view'
templates = require '../../templates'

module.exports = class NumberPrefix extends SelectView
  template: templates.includes.form.input

  constructor: (opts) ->
    super(opts)
    @.parent.on 'change:type', (event) =>
      if event.value is 'number'
        $(@.el).show()
      else
        $(@.el).hide()