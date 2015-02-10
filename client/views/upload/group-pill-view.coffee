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
        if @.ready.indexOf(':') is -1
          setCount = @.model.sets.length
          readySetCount = 0
          @.model.sets.each (set) =>
            if not set.analysis? then return
            if set.analysis[@.ready]?
              readySetCount++
          return setCount is readySetCount
        else
          bits = @.ready.split(':')
          if bits.length is 2
            [part1, part2] = bits
            if not @.model.analysis[part1]? then return no
            return @.model.analysis[part1][part2] #for two part we assume the part2 two should be truthy
          else
            [part1,part2,part3] = bits
            totalCount = 0
            truthCount = 0
            if part1 is 'readings'
              @.model.sets.each (set) ->
                set.readings.each (reading) ->
                  totalCount++
                  if reading.analysis[part2]? and reading.analysis[part2][part3]? and reading.analysis[part2][part3]
                    truthCount++
            else #sets
              alert 'NOT IMPLEMENTED'
            return totalCount is truthCount


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


