View = require 'ampersand-view'
templates = require '../../../templates'
async = require 'async'
_ = require 'lodash'

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

    @.currentView = 'graph'
    @.on 'change:model', () =>
      switch @.currentView
        when 'graph' then @.showGraphView()
        when 'data' then @.showDataView()
        when 'config' then @.showConfigView()

    switch @.model.mode
      when 'subject' then @.prepareDataSubjectSimpleDate() #TODO in future use user setting to decide what date ranges
      when 'group' then @.prepareDataSingleGroup()

    return @

  #for graphing reasons I am treating 120 as no response which allows for averaging up to their from 100.
  handleNoResponse = (level) ->
    if level < 0 then return 120 else return level

  prepareDataSubjectSimpleDate: () ->
    @.model.groupBy = 'date-simple'

    async.parallel [
      (cb) => $.get '/api/abr/groups', {subjectId: @.model.model.id}, (groups) -> cb(null, groups)
      (cb) => $.get '/api/abr/sets', {subjectId: @.model.model.id}, (sets) -> cb(null, sets)
    ], (err, data) =>

      groupLookup = {}
      clickData = {}
      toneData = {}
      groupNames = []

      for group in data[0]
        dateName = group.date.split('T')[0]
        groupNames.push dateName
        groupLookup[group.id] = {group: dateName, type: group.type}
      for set in data[1]
        group = groupLookup[set.groupId]
        if group.type is 'click'
          if not clickData[group.group]? then clickData[group.group] = []
          clickData[group.group].push handleNoResponse(set.analysis.threshold.level)
        else
          if not toneData[group.group]? then toneData[group.group] = {}
          if not toneData[group.group][set.freq]? then toneData[group.group][set.freq] = []
          toneData[group.group][set.freq].push handleNoResponse(set.analysis.threshold.level)

      groupNames = _.uniq(groupNames)
      @.model.data =
        groups: groupNames
        clickData: clickData
        toneData: toneData
      @.trigger 'change:model'


  prepareDataSingleGroup: () ->
    @.model.groupBy = 'N/A'

    $.get '/api/abr/sets', {groupId: @.model.model.id}, (sets) =>

      data = []
      for set in sets
        if set.analysis?.threshold?.level?
          if set.isClick
            data.push
              freq: null
              level: handleNoResponse(set.analysis.threshold.level)
          else
            data.push
              freq: set.freq
              level: handleNoResponse(set.analysis.threshold.level)

      @.model.data = data
      @.trigger 'change:model'