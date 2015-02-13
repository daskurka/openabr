View = require 'ampersand-view'
PageView = require '../base.coffee'
templates = require '../../templates'
async = require 'async'

ExperimentModel = require '../../models/core/experiment.coffee'

DetailsCollection = require '../../collections/details-collection.coffee'

DetailListView = require '../../views/detail-list-view.coffee'
DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

SubjectCollection = require '../../collections/core/subjects.coffee'
CollectionView = require 'ampersand-collection-view'
ShortSubjectRow = require '../../views/subject/short-subject-row.coffee'

module.exports = PageView.extend

  pageTitle: 'Subject View'
  template: templates.pages.experiments.view

  props:
    timelineValues: 'array'
    groupView: 'object'
    subjectCollection: 'object'

  initialize: (spec) ->
    #load experiments
    model = new ExperimentModel(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

        #load subjects
        subjects = new SubjectCollection()
        subjects.on 'query:loaded', () => @.subjectCollection = subjects
        subjects.query {experiments: @.model.id }

  bindings:
    'model.name': '[data-hook~=title]'
    'model.description': '[data-hook~=description]'

  render: () ->
    @.renderWithTemplate()
    return @

  subviews:
    details:
      hook: 'details'
      waitFor: 'model'
      prepareView: (el) ->

        #subject specific
        col = new DetailsCollection()
        dataFields = new DataFieldsCollection()
        dataFields.loadFields 'experiment', () =>
          fixedFields = new FixedDataFieldsCollection()
          fixedFields.addFixedFields 'experiment'
          fixedFields.forEach (field) =>
            col.addField(field, @.model[field.dbName] ? null)
          if @.model.fields?
            dataFields.forEach (field) =>
              if field.dbName of @.model.fields
                col.addField(field, @.model.fields[field.dbName] ? null)

        return new DetailListView(el: el, collection: col)

    subjects:
      hook: 'subjects'
      waitFor: 'subjectCollection'
      prepareView: (el) ->
        return new CollectionView(el: el, view: ShortSubjectRow, collection: @.subjectCollection)


  events:
    'click [data-hook="return"]': 'return'
    'click [data-hook="edit"]': 'edit'
    'click [data-hook="remove"]': 'showRemove'

  showRemove: () ->
    app.navigate(@.model.removeUrl)

  return: () ->
    app.navigate('experiments')

  edit: () ->
    app.navigate(@.model.editUrl)