View = require 'ampersand-view'
templates = require '../../templates'


module.exports = View.extend

  template: templates.views.upload.setListView

  session:
    ready: 'string'

  events:
    'click [data-hook~=list-group-item]': 'clicked'

  derived:
    showReady:
      deps: ['ready','model.analysis']
      fn: () ->
        if @.ready is '' then return false #not using it
        @.routeEventsTo.trigger 'change:ready'
        return @.model.analysis[@.ready]?


  bindings:
    'model.nameHtml':
      type: 'innerHTML'
      hook: 'name'
    'model.selected':
      type: 'booleanClass'
      hook: 'list-group-item'
      yes: 'active'
      no: 'not-active'
    'showReady':
      type: 'toggle'
      hook: 'set-ready'

  initialize: (spec) ->
    @.ready = if spec.ready then spec.ready else ''
    @.routeEventsTo = spec.routeEventsTo? and spec.routeEventsTo

  render: () ->
    @.renderWithTemplate()

    @.parent.on 'set-list-item:selection:changed', () =>
      @.model.selected = no

    return @

  clicked: () ->
    @.parent.trigger 'set-list-item:selection:changed' #clear all
    @.model.selected = yes
    @.routeEventsTo.trigger 'set-list-item:clicked', @.model