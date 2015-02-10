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

  initialize: (spec) ->
    @.currentSet = spec.currentSet
    @.currentGroup = spec.currentGroup
    console.log spec
    console.log @.currentGroup

    #check if complete
    @.complete = @.model.analysis? and @.model.analysis.latency? and @.model.analysis.latency.complete

  markComplete: () ->
    @.complete = yes
    if not @.model.analysis? then @.model.analysis = {}
    if not @.model.analysis.latencyAnalysis? then @.model.analysis.latency = {}
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

    peakData = [
      {number: 1, circleId: 'pkCircle1', boxId: 'pkBox1', label: 'I', isMarked: no, type: 'peak'}
      {number: 2, circleId: 'pkCircle2', boxId: 'pkBox2', label: 'II', isMarked: no, type: 'peak'}
      {number: 3, circleId: 'pkCircle3', boxId: 'pkBox3', label: 'III', isMarked: no, type: 'peak'}
      {number: 4, circleId: 'pkCircle4', boxId: 'pkBox4', label: 'IV', isMarked: no, type: 'peak'}
      {number: 5, circleId: 'pkCircle5', boxId: 'pkBox5', label: 'V', isMarked: no, type: 'peak'}
      {number: -1, circleId: 'trCircle1', boxId: 'trBox1', label: '-I', isMarked: no, type: 'trough'}
      {number: -2, circleId: 'trCircle2', boxId: 'trBox2', label: '-II', isMarked: no, type: 'trough'}
      {number: -3, circleId: 'trCircle3', boxId: 'trBox3', label: '-III', isMarked: no, type: 'trough'}
      {number: -4, circleId: 'trCircle4', boxId: 'trBox4', label: '-IV', isMarked: no, type: 'trough'}
      {number: -5, circleId: 'trCircle5', boxId: 'trBox5', label: '-V', isMarked: no, type: 'trough'}
    ]

    setMaxVoltage = @.currentGroup.maxAmpl
    setMinVoltage = @.currentGroup.minAmpl

    graphEl = @.query('#abrGraph')
    @.graph = new AbrLatencyAnalysisGraph(@.model.values,@.model.sampleRate,830,550,margin,setMaxVoltage,setMinVoltage,peakData)
    @.graph.render(graphEl)

    return @




