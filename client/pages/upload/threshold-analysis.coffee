PageView = require './../base.coffee'
templates = require '../../templates'

ViewSwitcher = require 'ampersand-view-switcher'
GroupThresholdAnalysisView = require '../../views/analysis/group-threshold.coffee'

CollectionView = require 'ampersand-collection-view'
GroupPillView = require '../../views/upload/group-pill-view.coffee'

module.exports = PageView.extend

  pageTitle: 'Threshold Analysis'
  template: templates.pages.upload.thresholdAnalysis

  initialize: () ->
    #mark first selected model
    @.model.groups.models[0].selected = yes

    #catch change group event
    @.on 'group-pill:clicked', (group) ->
      @.switcher.set new GroupThresholdAnalysisView(model: group)

  render: () ->
    @.renderWithTemplate()

    #we have to wait for render template before adding the switcher
    @.switcher = new ViewSwitcher(@.queryByHook('analysis-area'))

    #show first index
    @.switcher.set new GroupThresholdAnalysisView(model: @.model.groups.models[0])

    return @

  events:
    'click [data-hook~=cancel]': 'cancel'
    'click [data-hook~=next]': 'next'
    'click [data-hook~=autonext]': 'automaticAndNextStep'
    'click #modalQuit': 'quit'
    'click #modelNext': 'goNextStep'

  cancel: () -> $('#leaveModal').modal('show')
  quit: () -> app.navigate('')
  next: () ->
    setCount = 0
    analysedCount = 0
    @.model.groups.each (group) ->
      group.sets.each (set) ->
        setCount++
        if set.analysis.thresholdAnalysis?
          analysedCount++

    if setCount isnt analysedCount
      $('#notCompletedAnalysisModal').modal('show')
    else
      do @.goNextStep
  goNextStep: () -> app.router.uploadLatencyAnalysis(@.model)
  automaticAndNextStep: () ->
    @.model.groups.each (group) ->
      tempView = new GroupThresholdAnalysisView(model: group)
      tempView.autoThresholdAllSets()
    do @.goNextStep

  subviews:
    groupSelector:
      hook: 'group-select-list'
      waitFor: 'model'
      prepareView: (el) ->
        return new CollectionView
          el: el
          collection: @.model.groups
          view: GroupPillView
          viewOptions: {ready: 'thresholdAnalysis', routeEventsTo: @}
