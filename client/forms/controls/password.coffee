View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.form.password

  bindings:
    'label': [
        hook: 'label'
      ,
        hook: 'label-confirm'
        type: (el, value) -> el.innerText = "Confirm #{value}"
    ]
    'message':
      type: 'text'
      hook: 'message-text'
    'showMessage':
      type: 'toggle'
      hook: 'message-container'

  props:
    name: 'string'
    label: 'string'
    inputValue: 'string'
    confirmValue: 'string'
    message: ['string','',no]
    runTests: ['boolean', false, false]

  derived:
    value:
      deps: ['inputValue']
      fn: () -> return @.inputValue
    valid:
      deps: ['inputValue','confirmValue']
      fn: () -> return @.inputValue is @.confirmValue
    showMessage:
      deps: ['message']
      fn: () -> return @.message

  render: () ->
    do @.renderWithTemplate

    @.initial = @.queryByHook('password-input')
    @.confirm = @.queryByHook('password-input-confirm')

    @.initInputBindings()

    return @

  handleInitialChanged: () ->
    @.inputValue = @.initial.value
    if @.runTests then do @.checkIfValid

  handleConfirmChanged: () ->
    @.confirmValue = @.confirm.value
    if @.runTests then do @.checkIfValid

  checkIfValid: () ->
    if not @.valid
      @.message = 'The passwords provided do not match. Please try again.'
    else
      @.message = ''

  setValue: (value) ->
    @.initial.value = value
    @.confirm.value = value

  handleConfirmBlur: () ->
    @.runTests = yes
    do @.checkIfValid

  initInputBindings: () ->
    @.initial.addEventListener('input', @.handleInitialChanged.bind(@), false)
    @.confirm.addEventListener('input', @.handleConfirmChanged.bind(@), false)
    @.confirm.addEventListener('blur', @.handleConfirmBlur.bind(@), false)

  remove: () ->
    @.initial.removeEventListener('input', @.handleInitialChanged, false)
    @.confirm.removeEventListener('input', @.handleConfirmChanged, false)
    @.confirm.removeEventListener('blur', @.handleConfirmBlur, false)
    View.prototype.remove.apply(@, arguments)

  reset: () ->
    @.setValue('')

  clear: () ->
    @.setValue('')

  reportToParent: () -> if @.parent then @.parent.update(@)





