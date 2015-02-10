View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.views.upload.readingListView

  session:
    ready: 'string'

  events:
    'click [data-hook~=list-group-item]': 'clicked'

  derived:
    showReady:
      deps: ['ready','model.analysis']
      fn: () ->
        if @.ready is '' then return false #not using it
        @.routeEventsTo.trigger 'change:reading:ready'
        if @.ready.indexOf(':') is -1
          return @.model.analysis[@.ready]?
        else
          [part1, part2] = @.ready.split(':')
          if not @.model.analysis[part1]? then return no
          return @.model.analysis[part1][part2] #for two part we assume the part2 two should be truthy

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
      hook: 'item-ready'

  initialize: (spec) ->
    @.ready = if spec.ready then spec.ready else ''
    @.routeEventsTo = spec.routeEventsTo? and spec.routeEventsTo

  render: () ->
    @.renderWithTemplate()

    @.parent.on 'reading-list-item:selection:changed', () =>
      @.model.selected = no

    return @

  clicked: () ->
    @.parent.trigger 'reading-list-item:selection:changed' #clear all
    @.model.selected = yes
    @.routeEventsTo.trigger 'reading-list-item:clicked', @.model