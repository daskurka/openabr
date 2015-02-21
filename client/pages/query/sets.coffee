CollectionView = require 'ampersand-collection-view'
select2 = require 'select2'

PageView = require '../base.coffee'
templates = require '../../templates'

SetModel = require '../../models/core/abr-set.coffee'
SetCollection = require '../../collections/core/abr-sets.coffee'
SetRowView = require '../../views/abr-set/abr-set-query-row.coffee'

PagerView = require '../../views/pager.coffee'
PagerState = require '../../configurations/pager.coffee'

Select2Configs = require '../../utils/select2-configurations.coffee'

after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'Query ABR Sets'
  template: templates.pages.query.sets

  session:
    experiments: 'array'
    subjects: 'array'

  initialize: () ->
    @.collection = new SetCollection()

  render: () ->
    @.renderWithTemplate()

    #subject
    subjectFilterEl = @.query('#subjects')
    subjectConfig = Select2Configs.buildSubject('Filter by subject...',yes)
    $(subjectFilterEl).select2(subjectConfig)
    $(subjectFilterEl).on 'change', (event) => @.handleFilterChanged(event)

    #experiment
    experimentFilterEl = @.query('#experiments')
    experimentConfig = Select2Configs.buildExperiment('Filter by experiment...',yes)
    $(experimentFilterEl).select2(experimentConfig)
    $(experimentFilterEl).on 'change', (event) => @.handleFilterChanged(event)

    return @

  subviews:
    readings:
      hook: 'sets-table'
      waitFor: 'collection'
      prepareView: (el) ->
        view = new CollectionView(el: el, collection: @.collection, view: SetRowView)
        @.filterSets()
        return view

    pager:
      hook: 'pagination-control'
      waitFor: 'collection'
      prepareView: (el) ->
        return new PagerView(el: el, model: new PagerState(collection: @.collection))

  filterSets: () ->
    query = {}
    if @.subjects? and @.subjects.length > 0
      query.subjectId = { $in: @.subjects}
    if @.experiments? and @.experiments.length > 0
      query.experiments = {$in: @.experiments}

    @.collection.queryPaged 1,12, query

  handleFilterChanged: (event) ->
    if event.target.id is 'subjects'
      @.subjects = event.val
    else
      @.experiments = event.val
    @.filterSets()