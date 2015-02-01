InputView = require 'ampersand-input-view'
templates = require '../../templates'
_ = require 'underscore'

module.exports = InputView.extend
  template: templates.includes.form.number

  props:
    unit: 'string'
    prefix: 'string'

  derived:
    unitPrefix:
      deps: ['unit','prefix']
      fn: () -> return @.prefix + @.unit

  bindings: _.extend {}, InputView.prototype.bindings,
    'unitPrefix':
      type: 'text'
      hook: 'unit-prefix'

