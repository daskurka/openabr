PageView = require './../base.coffee'
templates = require '../../templates'

ViewSwitcher = require 'ampersand-view-switcher'
GroupLatencyAnalysisView = require '../../views/analysis/group-latency.coffee'

CollectionView = require 'ampersand-collection-view'
GroupPillView = require '../../views/upload/group-pill-view.coffee'

module.exports = PageView.extend

  pageTitle: 'Latency Analysis'
  template: templates.pages.upload.latencyAnalysis

  initialize: () ->
    #unselect all groups and reselect the first model
    @.model.groups.each (group) -> group.selected = no
    @.model.groups.models[0].selected = yes

    #catch change group event
    @.on 'group-pill:clicked', (group) ->
      @.switcher.set new GroupLatencyAnalysisView(model: group)

  render: () ->
    @.renderWithTemplate()

    #we have to wait for render template before adding the switcher
    @.switcher = new ViewSwitcher(@.queryByHook('analysis-area'))

    #show first index
    @.switcher.set new GroupLatencyAnalysisView(model: @.model.groups.models[0])

    return @

  events:
    'click [data-hook~=cancel]': 'cancel'
    'click [data-hook~=next]': 'next'
    'click #modalQuit': 'quit'
    'click #modelNext': 'goNextStep'

  cancel: () -> $('#leaveModal').modal('show')
  quit: () -> app.navigate('')
  next: () ->
    readingCount = 0
    analysedCount = 0
    @.model.groups.each (group) ->
      group.sets.each (set) ->
        set.readings.each (reading) ->
          readingCount++
          if reading.analysis? and reading.analysis.latency? and reading.analysis.latency.complete? and reading.analysis.latency.complete
            analysedCount++

    if readingCount isnt analysedCount
      $('#notCompletedAnalysisModal').modal('show')
    else
      do @.goNextStep
  goNextStep: () -> app.router.uploadReviewAndCommit(@.model)

  subviews:
    groupSelector:
      hook: 'group-select-list'
      waitFor: 'model'
      prepareView: (el) ->
        return new CollectionView
          el: el
          collection: @.model.groups
          view: GroupPillView
          viewOptions: {ready: 'readings:latency:complete', routeEventsTo: @}