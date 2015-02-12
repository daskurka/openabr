View = require 'ampersand-view'

SubjectTimelineGraph = require '../../graphs/subject-timeline-graph.coffee'
AbrGroupCollection = require '../../collections/core/abr-groups.coffee'

async = require 'async'

addDays = (date, days) ->
  result = new Date(date)
  result.setDate(date.getDate() + days)
  return result

module.exports = View.extend

  template: () -> '<div data-hook="timeline-graph"></div>'

  props:
    timelineGraph: 'object'
    values: 'array'
    maxDate: 'date'
    minDate: 'date'

  collections:
    toneGroups: AbrGroupCollection
    clickGroups: AbrGroupCollection

  initialize: () ->
    #calculate date ranges
    @.minDate = @.model.dob
    if @.model.dod?
      @.maxDate = @.model.dod
    else
      @.maxDate = addDays(new Date(), 30)

    @.on 'left-click:group right-click:group', (groupData) =>
      group = if groupData.type is 'tone' then @.toneGroups.get(groupData.id) else @.clickGroups.get(groupData.id)
      @.parent.trigger 'timeline:click:group', group

    @.on 'enter:group', (groupData) =>
      group = if groupData.type is 'tone' then @.toneGroups.get(groupData.id) else @.clickGroups.get(groupData.id)
      @.parent.trigger 'timeline:enter:group', group

    @.on 'exit:group', (groupData) =>
      group = if groupData.type is 'tone' then @.toneGroups.get(groupData.id) else @.clickGroups.get(groupData.id)
      @.parent.trigger 'timeline:exit:group', group

  render: () ->
    @.renderWithTemplate()

    graphEl = @.queryByHook('timeline-graph')
    #TODO - auto detect with so this control becomes flexiable
    @.timelineGraph = new SubjectTimelineGraph(graphEl, @, @maxDate, @minDate, 750, 180)

    async.parallel
      toneEvents: (cb) =>
        @.toneGroups = new AbrGroupCollection()
        @.toneGroups.on 'query:loaded', () =>
          tEvents = @.toneGroups.map (toneGroup) ->
            return {id: toneGroup.id, date: toneGroup.date, name: toneGroup.name, type: 'tone'}
          cb(null, tEvents)
        @.toneGroups.query {subjectId: @.model.subjectId, type: 'tone'}

      clickEvents: (cb) =>
        @.clickGroups = new AbrGroupCollection()
        @.clickGroups.on 'query:loaded', () =>
          cEvents = @.clickGroups.map (clickGroup) ->
            return {id: clickGroup.id, date: clickGroup.date, name: clickGroup.name, type: 'click'}
          cb(null, cEvents)
        @.clickGroups.query {subjectId: @.model.subjectId, type: 'click'}
    , (err, results) =>
        events = []
        events.push event for event in results.clickEvents
        events.push event for event in results.toneEvents

        #other types of events would go here!
        @.timelineGraph.render(events)

    return @