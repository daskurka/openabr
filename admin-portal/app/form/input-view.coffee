InputView = require 'ampersand-input-view'
Template = require './input-template.jade'

module.exports = InputView.extend
  template: Template

  session:
    hint: 'string'

  bindings: _.extend {}, InputView.prototype.bindings,
    'hint':
      type: 'text'
      hook: 'hint'
