View = require 'ampersand-view'
templates = require '../../templates'
CollectionView = require 'ampersand-collection-view'
ViewSwitcher = require 'ampersand-view-switcher'

SetThresholdAnalysisView = require '../../views/analysis/set-threshold.coffee'
SetListView = require '../../views/upload/set-list-view.coffee'

calcBogaerts = require '../../utils/bogaerts-threshold-analysis.coffee'

module.exports = View.extend

  template: templates.views.analysis.groupThreshold

  bindings:
    'model.name': '[data-hook~=name]'

  initialize: () ->
    #mark first selected model
    @.model.sets.each (set) -> set.selected =no
    @.model.sets.models[0].selected = yes

    #catch change set event
    @.on 'set-list-item:clicked', (group) ->
      @.switcher.set new SetThresholdAnalysisView(model: group)

    #catch updates from sets
    @.on 'change:ready', () ->
      @.model.trigger 'change:sets'

  events:
    'click [data-hook~=auto-threshold-group]': 'autoThresholdAllSets'

  render: () ->
    @.renderWithTemplate()

    #we have to wait for render template before adding the switcher
    @.switcher = new ViewSwitcher(@.queryByHook('analysis-area'))

    #show first index
    @.switcher.set new SetThresholdAnalysisView(model: @.model.sets.models[0])

    return @

  subviews:
    setSelector:
      hook: 'set-select-list'
      waitFor: 'model'
      prepareView: (el) ->
        return new CollectionView
          el: el
          collection: @.model.sets
          view: SetListView
          viewOptions: {ready: 'thresholdAnalysis', routeEventsTo: @}

  autoThresholdAllSets: () ->
    @.model.sets.each (set) ->
      abr = calcBogaerts(set.readings)
      level = if abr is null then -1 else abr.level
      if not set.analysis? then set.analysis = {}
      analysis = set.analysis
      analysis.thresholdAnalysis = {level, auto: yes, method: 'Bogaerts et al (2009)'}
      set.set('analysis',analysis)
      set.trigger 'change:analysis'
    @.model.trigger 'change:sets'
