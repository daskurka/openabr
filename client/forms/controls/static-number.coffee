View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.form.staticNumber

  session:
    label: 'string'
    value: 'any'
    valid: ['boolean',no,yes]
    parent: 'any'
    unit: 'string'
    prefix: 'string'

  derived:
    unitPrefix:
      deps: ['unit', 'prefix']
      fn: () -> return @.prefix + @.unit

  bindings:
    'label': '[data-hook~=label]'
    'value':
      type: 'attribute'
      name: 'value'
      hook: 'value'
    'unitPrefix': '[data-hook~=unit-prefix]'

  initialize: (spec) ->
    @.value = spec.value
    @.name = spec.name
    @.label = spec.label
    @.parent = spec.parent

  setValue: (value) ->
    @.value = value