View = require 'ampersand-view'
PageView = require '../base.coffee'
templates = require '../../templates'
async = require 'async'

ViewSwitcher = require 'ampersand-view-switcher'

SubjectModel = require '../../models/core/subject.coffee'
DetailsCollection = require '../../collections/details-collection.coffee'

DetailListView = require '../../views/detail-list-view.coffee'
DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

SelectSubjectExperimentsView = require '../../views/subject/select-subject-experiments-view.coffee'

TimelineView = require '../../views/subject/timeline-view.coffee'
AbrGroupShowView = require '../../views/abr-group/show.coffee'

ThresholdGraphView = require '../../views/graphs/threshold/main.coffee'
LatencyGraphView = require '../../views/graphs/latency/main.coffee'

module.exports = PageView.extend

  pageTitle: 'Subject View'
  template: templates.pages.subjects.view

  props:
    timelineValues: 'array'
    groupView: 'object'

  initialize: (spec) ->
    model = new SubjectModel(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

    @.on 'timeline:click:group', (group) =>
      @.groupView.set new AbrGroupShowView(model: group)

    @.on 'timeline:enter:group', (group) ->
      #TODO link this to the subject graph

    @.on 'timeline:exit:group', (group) ->
      #TODO link this to the subject graph

  derived:
    age:
      deps: ['model.dob','model.dod']
      fn: () ->
        current = if @.model.dod? and @.model.dod.getTime() isnt 0 then @.model.dod else Date.now()
        diff = current - @.model.dob.getTime()
        weeks = Math.ceil(diff / 604800000)
        return weeks
    subtitle:
      deps: ['model','model.species','model.strain','age','model.dod']
      fn: () ->
        if not @.model? then return 'loading...'
        agePart = if @.model.dod? and @.model.dod.getTime() isnt 0 then "(lived #{@.age} weeks)" else "(#{@.age} weeks old)"
        return "#{@.model.strain} #{@.model.species} #{agePart}"

  bindings:
    'model.reference': '[data-hook~=title]'
    'subtitle': '[data-hook~=subtitle]'

  render: () ->
    @.renderWithTemplate()
    @.groupView = new ViewSwitcher(@.queryByHook('group-show'))
    return @

  subviews:
    experiments:
      hook: 'experiments'
      waitFor: 'model'
      prepareView: (el) ->
        return new SelectSubjectExperimentsView(el: el, model: @.model)

    timeline:
      hook: 'timeline'
      waitFor: 'model'
      prepareView: (el) ->
        return new TimelineView(el: el, model: @.model)

    details:
      hook: 'details'
      waitFor: 'model'
      prepareView: (el) ->

        #subject specific
        col = new DetailsCollection()
        dataFields = new DataFieldsCollection()
        dataFields.loadFields 'subject', () =>
          fixedFields = new FixedDataFieldsCollection()
          fixedFields.addFixedFields 'subject'
          fixedFields.forEach (field) =>
            if field.type is 'experiments' then return #subject specific, already showing this
            col.addField(field, @.model[field.dbName] ? null)
          if @.model.fields?
            dataFields.forEach (field) =>
              if field.dbName of @.model.fields
                col.addField(field, @.model.fields[field.dbName] ? null)

        return new DetailListView(el: el, collection: col)

    latencyGraph:
      hook: 'latency-analysis-graph'
      waitFor: 'model'
      prepareView: (el) ->
        $('#graphTabs a[href="#latency-analysis-tab"]').tab('show')
        return new LatencyGraphView(el: el, type: 'subject', subject: @.model)

    thresholdGraph:
      hook: 'threshold-analysis-graph'
      waitFor: 'model'
      prepareView: (el) ->
        $('#graphTabs a[href="#threshold-analysis-tab"]').tab('show')
        return new ThresholdGraphView(el: el, type: 'subject', subject: @.model)

  events:
    'click [data-hook="return"]': 'return'
    'click [data-hook="edit"]': 'edit'
    'click [data-hook="remove"]': 'showRemove'

  showRemove: () ->
    app.navigate(@.model.removeUrl)

  return: () ->
    app.navigate('subjects')

  edit: () ->
    app.navigate(@.model.editUrl)