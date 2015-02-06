View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.views.upload.setView

  initialize: () ->
    @.model.selected = yes #all selected by default

  events:
    'click [data-hook~=set-click-area]': 'toggleSelected'

  bindings:
    'model.name': '[data-hook~=name]'
    'model.readings.length': '[data-hook~=reading-count]'
    'model.selected': [
        type: 'toggle'
        yes: '#is-selected'
        no: '#not-selected'
      ,
        type: 'booleanClass'
        hook: 'set-click-area'
        yes: ''
        no: 'unselected-set-area'
    ]

  toggleSelected: () ->
    @.model.selected = not @.model.selected #toggle
