View = require 'ampersand-view'
templates = require '../../templates'


module.exports = View.extend

  template: templates.views.upload.groupPillView

  session:
    ready: 'string'

  events:
    'click [data-hook~=group-list-item]': 'clicked'

  derived:
    showReady:
      deps: ['ready','model.sets']
      fn: () ->
        if @.ready is '' then return false #not using it
        setCount = @.model.sets.length
        readySetCount = 0
        @.model.sets.each (set) =>
          if not set.analysis? then return
          if set.analysis[@.ready]?
            readySetCount++
        return setCount is readySetCount

  bindings:
    'model.name': '[data-hook~=name]'
    'model.selected':
      type: 'booleanClass'
      hook: 'group-list-item'
      yes: 'active'
      no: 'not-active'
    'showReady':
      type: 'toggle'
      hook: 'group-ready'

  initialize: (spec) ->
    @.ready = if spec.ready then spec.ready else ''
    @.routeEventsTo = spec.routeEventsTo? and spec.routeEventsTo

  render: () ->
    @.renderWithTemplate()

    @.parent.on 'group-pill:selection:changed', () =>
      @.model.selected = no

    return @

  clicked: () ->
    @.parent.trigger 'group-pill:selection:changed' #clear all
    @.model.selected = yes
    @.routeEventsTo.trigger 'group-pill:clicked', @.model


