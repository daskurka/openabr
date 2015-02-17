View = require 'ampersand-view'
templates = require '../../../templates'

ViewSwitcher = require 'ampersand-view-switcher'

LatencyGraphModel = require '../../../models/graph/latency.coffee'

GraphView = require './graph.coffee'
DataView = require './data.coffee'
ConfigView = require './config.coffee'

module.exports = View.extend

  template: templates.views.graphs.latency.main

  events:
    'click #showGraphPill': 'showGraphView'
    'click #showDataPill': 'showDataView'
    'click #showConfigPill': 'showConfigView'

  showGraphView: () ->
    $('ul li', @.el).removeClass('active')
    $('#showGraphPill', @.el).parent().addClass('active')
    @.switcher.set new GraphView(model: @.model, parent: @)
  showDataView: () ->
    $('ul li', @.el).removeClass('active')
    $('#showDataPill', @.el).parent().addClass('active')
    @.switcher.set new DataView(model: @.model, parent: @)
  showConfigView: () ->
    $('ul li', @.el).removeClass('active')
    $('#showConfigPill', @.el).parent().addClass('active')
    @.switcher.set new ConfigView(model: @.model, parent: @)

  initialize: () ->
    @.model = new LatencyGraphModel()



  render: () ->
    @.renderWithTemplate()

    #set up the view switcher
    @.switcher = new ViewSwitcher(@.queryByHook('switch-area'))

    #We need to know how much space we have for threshold graph
    graphWidth = parseInt(window.getComputedStyle(@.el).width.replace('px',''))
    graphHeight = graphWidth / 2

    #console.log graphWidth
    #console.log graphHeight


    #show graph view first
    do @.showGraphView



