View = require 'ampersand-view'
templates = require '../../../templates'

async = require 'async'
_ = require 'lodash'
d3 = require 'd3'

SubjectModel = require '../../../models/core/subject.coffee'
AbrThresholdAnalysisGraph = require '../../../graphs/abr-threshold-analysis-graph.coffee'

module.exports = View.extend

  template: templates.views.graphs.threshold.graph

  session:
    graph: 'object'

  initialize: () ->
    @.graph = new AbrThresholdAnalysisGraph(@.model.graphWidth, @.model.graphHeight, @)

  render: () ->
    @.renderWithTemplate()

    #catch model ready event to show graph
    @.on 'model:ready', () =>
      @graphEl = @.queryByHook('threshold-analysis-graph')
      if @.model.mode is 'group'
        @.graph.renderSingleGroup(@graphEl, @.model.data)
      else
        switch @.model.groupBy
          when 'date-simple'
            @.graph.renderDateSimple(@graphEl, @.model.data.toneData, @.model.data.clickData, @.model.data.groups)
          when 'age-monthly'
            @.graph.renderAgeHist(@graphEl, @.model.data)
          when 'strain-age-monthly'
            @.graph.renderStrainAgeHist(@graphEl, @.model.data)

    @.model.on 'change', () =>
      @.processData()

    @.processData()

  processData: () ->
    #start processing data
    #we need to process the data the correct way
    switch "#{@.model.mode}-#{@.model.groupBy}"
      when 'subject-age-monthly' then do @.prepareDataSubjectAgeMonthly
      when 'subject-date-simple' then do @.prepareDataSubjectSimpleDate
      when 'group-N-A' then do @.prepareDataSingleGroup
      when 'sets-age-monthly' then do @.prepareDataSetsAgeMonthly
      when 'sets-date-simple' then do @.prepareDataSetsDateSimple
      when 'sets-strain-age-monthly' then do @.prepareDataSetsStrainAgeMonthly


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
      @.trigger 'model:ready'


  prepareDataSingleGroup: () ->
    @.model.groupBy = 'N-A'

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
      @.trigger 'model:ready'

  calculateAgeInWeeks = (dob, date) ->
    diff = date - dob
    weeks = Math.ceil(diff / 604800000)
    return weeks

  prepareDataSubjectAgeMonthly: () ->
    @.model.groupBy = 'age-monthly'

    $.get '/api/abr/sets', {subjectId: @.model.model.id}, (sets) =>
      subjectName = @.model.model.reference
      subjectDob = @.model.model.dob

      data = []
      for set in sets
        if set.analysis?.threshold?.level?
          setDate = new Date(set.date)
          age = calculateAgeInWeeks(subjectDob.getTime(), setDate.getTime())
          data.push
            age: age
            date: setDate
            subject: subjectName
            freq: if set.isClick then null else set.freq
            level: handleNoResponse(set.analysis.threshold.level)

      maxAge = _.max(_.pluck(data,(d) -> d.age))

      domain = []
      for weeks in [0..12000] by 4
        domain.push weeks
        if weeks > maxAge
          break

      hist = d3.layout.histogram()
        .range([0,maxAge])
        .bins(domain)
        .value((d) -> d.age)

      @.model.data = hist(data)
      @.trigger 'model:ready'


  prepareDataSetsAgeMonthly: () ->
    @.model.groupBy = 'age-monthly'

    #make list of subject ids
    sets = @.model.model
    if sets.length <= 0
      console.log 'No sets in this experiment...'
      return

    #query subjects and extract reference and id into a lookup table
    subjectIds = sets.map((d) -> d.subjectId)
    subjectIds = _.uniq(subjectIds)
    subjectLookup = {}
    async.forEach subjectIds, (sid, cb) ->
      sub = new SubjectModel({id: sid})
      sub.fetch
        success: () ->
          subjectLookup[sid] = {name: sub.reference, dob: sub.dob, id: sid}
          do cb
    , () =>
      #go through sets adding data entries.
      data = []
      sets.each (set) ->
        if set.analysis?.threshold?.level?
          setDate = new Date(set.date)
          age = calculateAgeInWeeks(subjectLookup[set.subjectId].dob.getTime(), setDate.getTime())
          data.push
            age: age
            date: setDate
            subject: subjectLookup[set.subjectId].name
            freq: if set.isClick then null else set.freq
            level: handleNoResponse(set.analysis.threshold.level)

      maxAge = _.max(_.pluck(data,(d) -> d.age))

      domain = []
      for weeks in [0..12000] by 4
        domain.push weeks
        if weeks > maxAge
          break

      hist = d3.layout.histogram()
        .range([0,maxAge])
        .bins(domain)
        .value((d) -> d.age)

      @.model.data = hist(data)
      @.trigger 'model:ready'

  prepareDataSetsStrainAgeMonthly: () ->
    @.model.groupBy = 'strain-age-monthly'

    #make list of subject ids
    sets = @.model.model
    if sets.length <= 0
      console.log 'No sets in this experiment...'
      return

    #query subjects and extract reference and id into a lookup table
    subjectIds = sets.map((d) -> d.subjectId)
    subjectIds = _.uniq(subjectIds)
    subjectLookup = {}
    async.forEach subjectIds, (sid, cb) ->
      sub = new SubjectModel({id: sid})
      sub.fetch
        success: () ->
          subjectLookup[sid] = {name: sub.reference, dob: sub.dob, id: sid, strain: sub.strain}
          do cb
    , () =>
      #go through sets adding data entries.
      data = []
      sets.each (set) ->
        if set.analysis?.threshold?.level?
          setDate = new Date(set.date)
          age = calculateAgeInWeeks(subjectLookup[set.subjectId].dob.getTime(), setDate.getTime())
          data.push
            age: age
            date: setDate
            subject: subjectLookup[set.subjectId].name
            strain: subjectLookup[set.subjectId].strain
            freq: if set.isClick then null else set.freq
            level: handleNoResponse(set.analysis.threshold.level)

      maxAge = _.max(_.pluck(data,(d) -> d.age))

      domain = []
      for weeks in [0..12000] by 4
        domain.push weeks
        if weeks > maxAge
          break

      hist = d3.layout.histogram()
        .range([0,maxAge])
        .bins(domain)
        .value((d) -> d.age)

      @.model.data = hist(data)
      @.trigger 'model:ready'

  prepareDataSetsDateSimple: () ->
    @.model.groupBy = 'date-simple'

    console.log('not supported yet...')

    do @.prepareDataSetsAgeMonthly

