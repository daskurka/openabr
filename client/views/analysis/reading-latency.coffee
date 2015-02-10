View = require 'ampersand-view'
templates = require '../../templates'
CollectionView = require 'ampersand-collection-view'

AbrLatencyAnalysisGraph = require '../../graphs/abr-latency-graph.coffee'

module.exports = View.extend

  template: templates.views.analysis.readingLatency

  session:
    complete: ['boolean',yes,no]
    graph: 'object'

  derived:
    notComplete:
      deps: ['complete']
      fn: () -> return not @.complete

  bindings:
    'model.name': '[data-hook~=name]'
    'complete':
      type: 'toggle'
      selector: '#clear-complete'
    'notComplete':
      type: 'toggle'
      selector: '#mark-complete, #complete-and-next'

  events:
    'click #mark-complete': 'markComplete'
    'click #clear-complete': 'clearComplete'
    'click #complete-and-next': 'markCompleteAndNext'
    'click .mark-peak': 'markPeak'
    'click #mark-peaks': 'markPeaks'

  initialize: (spec) ->
    @.currentSet = spec.currentSet
    @.currentGroup = spec.currentGroup

    #check if complete
    @.complete = @.model.analysis? and @.model.analysis.latency? and @.model.analysis.latency.complete

    #catch when the peaks change
    @.on 'change:peaks', (peakConfig) =>
      if not @.model.analysis? then @.model.analysis = {}
      if not @.model.analysis.latency? then @.model.analysis.latency = {complete: no}
      analysis = @.model.analysis
      analysis.latency.peaks = []
      for i in [1..5]
        item = {number: i, peakAmpl: null, peakTime: null, troughAmpl: null, troughTime: null}
        if peakConfig["peak#{i}"].isMarked
          item.peakAmpl = peakConfig["peak#{i}"].amplitude
          item.peakTime = peakConfig["peak#{i}"].time
        if peakConfig["trough#{i}"].isMarked
          item.troughAmpl = peakConfig["trough#{i}"].amplitude
          item.troughTime = peakConfig["trough#{i}"].time
        analysis.latency.peaks.push item
      @.model.set('analysis',analysis)
      @.model.trigger('change:analysis')

  markComplete: () ->
    @.complete = yes
    if not @.model.analysis? then @.model.analysis = {}
    if not @.model.analysis.latency? then @.model.analysis.latency = {}
    analysis = @.model.analysis
    analysis.latency.complete = yes
    @.model.set('analysis',analysis)
    @.model.trigger('change:analysis')

  markCompleteAndNext: () ->
    @.markComplete()
    @.parent.trigger('movenext:reading')

  clearComplete: () ->
    @.complete = no
    if not @.model.analysis? then @.model.analysis = {}
    if not @.model.analysis.latency? then @.model.analysis.latency = {}
    analysis = @.model.analysis
    analysis.latency.complete = no
    @.model.set('analysis',analysis)
    @.model.trigger('change:analysis')

  render: () ->
    @.renderWithTemplate()

    #graph
    margin = { top: 20, right: 20, bottom: 130, left: 50 }

    setMaxVoltage = @.currentGroup.maxAmpl
    setMinVoltage = @.currentGroup.minAmpl

    graphEl = @.query('#abrGraph')
    @.graph = new AbrLatencyAnalysisGraph(@.model.values,@.model.sampleRate,830,550,margin,
                                          setMaxVoltage,setMinVoltage,@)
    @.graph.render(graphEl)

    if @.model.analysis?.latency?.peaks?
      @.graph.setPeaks(@.model.analysis.latency.peaks)

    return @

  markPeak: (event) ->
    peak = parseInt(event.target.attributes['data'].value)
    @.graph.markPeak(peak)

  markPeaks: () -> @.graph.markPeaks()




