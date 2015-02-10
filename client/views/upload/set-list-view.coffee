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
      deps: ['ready','model.analysis','model.readings']
      fn: () ->
        if @.ready is '' then return false #not using it
        @.routeEventsTo.trigger 'change:set:ready'
        if @.ready.indexOf(':') is -1
          return @.model.analysis[@.ready]?
        else
          bits = @.ready.split(':')
          if bits.length is 2
            [part1, part2] = bits
            if not @.model.analysis[part1]? then return no
            return @.model.analysis[part1][part2] #for two part we assume the part2 two should be truthy
          else
            #for now this will always be 'readings' as it is the only collection
            [part1, part2, part3] = bits
            if @.model.readings.length <= 0 then return no
            totalCount = 0
            truthCount = 0
            @.model.readings.each (reading) ->
              totalCount++
              if reading.analysis[part2]? and reading.analysis[part2][part3]? and reading.analysis[part2][part3]
                truthCount++
            return totalCount is truthCount

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