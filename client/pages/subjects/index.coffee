CollectionView = require 'ampersand-collection-view'

PageView = require '../base.coffee'
templates = require '../../templates'

SubjectModel = require '../../models/core/subject.coffee'
SubjectsCollection = require '../../collections/core/subjects.coffee'
SubjectView = require '../../views/items/subject.coffee'

PagerView = require '../../views/pager.coffee'
PagerState = require '../../configurations/pager.coffee'

after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'Subjects'
  template: templates.pages.subjects.index

  initialize: () ->
    @.collection = new SubjectsCollection()

  events:
    'click #newSubject': 'newSubject'
    'keyup [data-hook~=filter]': 'filterSubjects'

  subviews:
    subjects:
      hook: 'subjects-table'
      waitFor: 'collection'
      prepareView: (el) ->
        view = new CollectionView(el: el, collection: @.collection, view: SubjectView)
        @.filterSubjects()
        return view
    pager:
      hook: 'pagination-control'
      waitFor: 'collection'
      prepareView: (el) ->
        return new PagerView(model: new PagerState(collection: @.collection))

  newSubject: () ->
    app.navigate('/subjects/create')

  filterSubjects: () ->
    @.collection.query @.queryByHook('filter').value