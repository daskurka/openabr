View = require 'ampersand-view'
templates = require '../../templates'
CollectionView = require 'ampersand-collection-view'
ViewSwitcher = require 'ampersand-view-switcher'

ReadingLatencyAnalysisView = require '../../views/analysis/reading-latency.coffee'

SetListView = require '../../views/upload/set-list-view.coffee'
ReadingListView = require '../../views/upload/reading-list-view.coffee'

module.exports = View.extend

  template: templates.views.analysis.groupLatency

  props:
    currentSet: 'object'

  bindings:
    'model.name': '[data-hook~=name]'

  initialize: () ->
    #catch change set event
    @.on 'set-list-item:clicked', (set) ->
      @.switchSet(set)

    #catch change reading event
    @.on 'reading-list-item:clicked', (reading) ->
      @.switchReading(reading)

    #change move next events from a reading view
    @.on 'movenext:reading', () ->

      foundReading = no
      incompleteReadings = @.currentSet.readings.filter (r) ->
        return not (r.analysis? and r.analysis.latency? and r.analysis.latency.complete? and r.analysis.latency.complete)

      if incompleteReadings.length > 0
        @.switchReading(incompleteReadings[0])
        foundReading = yes

      if foundReading is no
        sets = @.model.sets.filter (s) ->
          return s.readings.some (r) ->
            return not (r.analysis? and r.analysis.latency? and r.analysis.latency.complete? and r.analysis.latency.complete)

        if sets.length > 0
          @.switchSet(sets[0])
        else
          if @.parent? then @.parent.trigger 'movenext:group'

    #catch updates from sets and readings (for passing analysis done events to parent)
    @.on 'change:reading:ready', () ->
      @.currentSet.trigger 'change:readings'
    @.on 'change:set:ready', () ->
      @.model.trigger 'change:sets'

  render: () ->
    @.renderWithTemplate()

    #we have to wait for render template before adding the switcher
    @.readingSwitcher = new ViewSwitcher(@.queryByHook('analysis-area'))
    @.readingListSwitcher = new ViewSwitcher(@.queryByHook('reading-select-list'))

    #show first index
    @.switchSet(@.model.sets.models[0])

    return @

  switchSet: (set) ->
    @.model.sets.each (s) -> s.selected = no
    @.currentSet = set
    @.currentSet.selected = yes
    @.currentSet.readings.each (reading) -> reading.selected = no
    @.switchReadingList()
    @.switchReading(@.currentSet.readings.models[0])

  switchReading: (reading) ->
    @.currentSet.readings.each (reading) -> reading.selected = no
    reading.selected = yes
    @.readingSwitcher.set new ReadingLatencyAnalysisView(model: reading, parent: @, currentSet: @.currentSet, currentGroup: @.model)

  switchReadingList: () ->
    collectionView = new CollectionView
      collection: @.currentSet.readings
      el: @.queryByHook('reading-select-list')
      view: ReadingListView
      viewOptions:
        ready: 'latency:complete'
        routeEventsTo: @
    collectionView.insertSelf = yes
    @.readingListSwitcher.set collectionView

  subviews:
    setSelector:
      hook: 'set-select-list'
      waitFor: 'model'
      prepareView: (el) ->
        return new CollectionView
          el: el
          collection: @.model.sets
          view: SetListView
          viewOptions:
            ready: 'readings:latency:complete'
            routeEventsTo: @