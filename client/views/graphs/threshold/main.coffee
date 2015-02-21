View = require 'ampersand-view'
templates = require '../../../templates'

ViewSwitcher = require 'ampersand-view-switcher'

ThresholdGraphModel = require '../../../models/graph/threshold.coffee'

GraphView = require './graph.coffee'
DataView = require './data.coffee'
ConfigView = require './config.coffee'

module.exports = View.extend

  template: templates.views.graphs.threshold.main

  session:
    subject: 'object'
    mode: 'string'
    currentView: 'string'

  events:
    'click #showGraphPill': 'showGraphView'
    'click #showDataPill': 'showDataView'
    'click #showConfigPill': 'showConfigView'

  showGraphView: () ->
    $('ul li', @.el).removeClass('active')
    $('#showGraphPill', @.el).parent().addClass('active')
    @.currentView = 'graph'
    @.switcher.set new GraphView(model: @.model, parent: @)
  showDataView: () ->
    $('ul li', @.el).removeClass('active')
    $('#showDataPill', @.el).parent().addClass('active')
    @.currentView = 'data'
    @.switcher.set new DataView(model: @.model, parent: @)
  showConfigView: () ->
    $('ul li', @.el).removeClass('active')
    $('#showConfigPill', @.el).parent().addClass('active')
    @.currentView = 'config'
    @.switcher.set new ConfigView(model: @.model, parent: @)

  initialize: (spec) ->
    @.model = new ThresholdGraphModel()
    @.model.mode = if spec.type? then spec.type else 'subject'
    switch @.model.mode
      when 'subject' then @.model.model = spec.subject
      when 'group' then @.model.model = spec.abrGroup
      when 'sets' then @.model.model = spec.sets

  render: () ->
    @.renderWithTemplate()

    #set up the view switcher
    @.switcher = new ViewSwitcher(@.queryByHook('switch-area'))

    #We need to know how much space we have for threshold graph
    graphWidth = parseInt(window.getComputedStyle(@.el).width.replace('px',''))
    if isNaN(graphWidth)
      graphWidth = 760 #TODO: replace this complete hack with something appropreate
    graphHeight = graphWidth / 2

    @.model.graphWidth = graphWidth
    @.model.graphHeight = graphHeight

    switch @.model.mode
      when 'subject' then @.model.groupBy = 'date-simple'
      when 'group' then @.model.groupBy = 'N-A'
      when 'sets' then @.model.groupBy = 'age-monthly'

    do @.showGraphView
    return @