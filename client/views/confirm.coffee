View = require 'ampersand-view'
templates = require '../templates'

module.exports = View.extend

  template: templates.includes.confirm

  bindings:
    'model.message': '[data-hook~=main-message]'
    'model.confirm': '[data-hook~=confirm-message]'
    'model.button':
      type: 'text'
      hook: 'main-button'

  events:
    'click [data-hook~=main-button]': 'first'
    'click [data-hook~=confirm-button]': 'confirm'
    'click [data-hook~=cancel-button]': 'cancel'

  render: () ->
    @.renderWithTemplate()

    @.queryByHook('main-section').style.display = 'block'
    @.queryByHook('confirm-section').style.display = 'none'

    return @

  initialize: (attr) ->
    if attr.action?
      @.action = attr.action
    else
      @.action = () -> console.log 'No action defined.'

  first: () ->
    @.queryByHook('main-section').style.display = 'none'
    @.queryByHook('confirm-section').style.display = 'block'

  confirm: () ->
    do @.action

  cancel: () ->
    @.queryByHook('main-section').style.display = 'block'
    @.queryByHook('confirm-section').style.display = 'none'

