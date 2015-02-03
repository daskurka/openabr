PageView = require '../base.coffee'
templates = require '../../templates'

SubjectModel = require '../../models/core/subject.coffee'
DetailsCollection = require '../../collections/details-collection.coffee'

DetailListView = require '../../views/detail-list-view.coffee'
DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

SelectSubjectExperimentsView = require '../../views/subject/select-subject-experiments-view.coffee'

module.exports = PageView.extend

  pageTitle: 'Subject View'
  template: templates.pages.subjects.view

  initialize: (spec) ->
    model = new SubjectModel(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

  derived:
    age:
      deps: ['model.dob','model.dod']
      fn: () ->
        current = if @.model.dod? then @.model.dod else Date.now()
        diff = current - @.model.dob.getTime()
        weeks = Math.ceil(diff / 604800000)
        return weeks
    subtitle:
      deps: ['model','model.species','model.strain','age']
      fn: () ->
        if not @.model? then return 'loading...'
        return "#{@.model.strain} #{@.model.species} (#{@.age} weeks)"

  bindings:
    'model.reference': '[data-hook~=title]'
    'subtitle': '[data-hook~=subtitle]'

  subviews:
    experiments:
      hook: 'experiments'
      waitFor: 'model'
      prepareView: (el) ->
        return new SelectSubjectExperimentsView(el: el, model: @.model)

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

  events:
    'click [data-hook="return"]': 'return'
    'click [data-hook="edit"]': 'edit'

  return: () ->
    app.navigate('subjects')

  edit: () ->
    app.navigate(@.model.editUrl)