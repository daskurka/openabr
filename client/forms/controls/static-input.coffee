View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.form.staticInput

  session:
    label: 'string'
    value: 'any'
    valid: ['boolean',no,yes]
    parent: 'any'

  bindings:
    'label': '[data-hook~=label]'
    'value':
      type: 'attribute'
      name: 'value'
      hook: 'value'

  initialize: (spec) ->
    @.value = spec.value
    @.name = spec.name
    @.label = spec.label
    @.parent = spec.parent

  setValue: (value) ->
    @.value = value