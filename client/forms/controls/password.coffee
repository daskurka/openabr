View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.form.password

  props: [
    value: 'string'
    valid: 'boolean'
    name: 'string'
    label: 'string'
  ]

  render: () ->
    do @.renderWithTemplate

    @.initial = @.queryByHook('password-input')
    @.confirm = @.queryByHook('password-input-confirm')




  handleInitialChanged: () ->
    console.log 'handle init hit'

  handleConfirmChanged: () ->
    console.log 'handle confirm hit'

  setValue: (value) ->
    @.initial.value = value
    @.confirm.value = value

  initInputBindings: () ->
    @.initial.addEventListener('input', @.handleInitialChanged, false)
    @.confirm.addEventListener('input', @.handleConfirmChanged, false)

  remove: () ->
    @.initial.removeEventListener('input', @.handleInitialChanged, false)
    @.confirm.removeEventListener('input', @.handleConfirmChanged, false)
    View.prototype.remove.apply(@, arguments)

  reset: () ->
    @.setValue('')

  clear: () ->
    @.setValue('')

  reportToParent: () -> if @.parent then @.parent.update(@)





