PageView = require './base.coffee'
templates = require '../templates'

CollectionView = require 'ampersand-collection-view'
SubjectRowView = require '../views/subject/subject-row.coffee'
ExperimentRowView = require '../views/experiment/experiment-row.coffee'

ExperimentCollection = require '../collections/core/experiments.coffee'
SubjectCollection = require '../collections/core/subjects.coffee'

module.exports = PageView.extend

  pageTitle: 'Status'
  template: templates.pages.status

  session:
    subjectCollection: 'object'
    experimentCollection: 'object'

  initialize: () ->
    subCol = new SubjectCollection()
    subCol.on 'page:loaded', () => @.subjectCollection = subCol
    subCol.queryPaged(1,14,{creator: app.me.user.id})

    expCol = new ExperimentCollection()
    expCol.on 'page:loaded', () => @.experimentCollection = expCol
    expCol.queryPaged(1,14,{creator: app.me.user.id})

  subviews:
    subjects:
      hook: 'subject-table'
      waitFor: 'subjectCollection'
      prepareView: (el) ->
        return new CollectionView(el: el, collection: @.subjectCollection, view: SubjectRowView)
    experiments:
      hook: 'experiment-table'
      waitFor: 'experimentCollection'
      prepareView: (el) ->
        return new CollectionView(el: el, collection: @.experimentCollection, view: ExperimentRowView)

