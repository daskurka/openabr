View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'

templates = require '../../templates'

ReadingListView = require '../../views/abr-reading/list.coffee'
ThresholdGraphView = require '../../views/graphs/threshold/main.coffee'
LatencyGraphView = require '../../views/graphs/latency/main.coffee'

module.exports = View.extend

  template: templates.views.abrGroups.show

  initialize: () ->
    #the model is a group, we need to turn it into a collection of ABR readings.
    @.model.getReadings (err, abrReadingCollection) =>
      @.collection = abrReadingCollection
      @.setCount = @.model.sets.length #now lazy loaded with above

  session:
    setCount: ['number',no,0]
    rendered: ['boolean',no,no]

  bindings:
    'model.name': '[data-hook~=title]'
    'model.date': '[data-hook~=subtitle]'
    'setCount': '[data-hook~=sets-count]'
    'collection.length': '[data-hook~=readings-count]'

  subviews:
    readingList:
      hook: 'readings-list'
      waitFor: 'collection'
      prepareView: (el) ->
        return new ReadingListView(el: el, collection: @.collection)

    latencyGraph:
      hook: 'latency-analysis-graph'
      waitFor: 'model'
      prepareView: (el) ->
        $('#groupTabs a[href="#latency"]').tab('show')
        return new LatencyGraphView(el: el, type: 'group', abrGroup: @.model)

    thresholdGraph:
      hook: 'threshold-analysis-graph'
      waitFor: 'model'
      prepareView: (el) ->
        $('#groupTabs a[href="#threshold"]').tab('show')
        return new ThresholdGraphView(el: el, type: 'group', abrGroup: @.model)
