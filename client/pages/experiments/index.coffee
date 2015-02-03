CollectionView = require 'ampersand-collection-view'

PageView = require '../base.coffee'
templates = require '../../templates'

ExperimentModel = require '../../models/core/experiment.coffee'
ExperimentsCollection = require '../../collections/core/experiments.coffee'
ExperimentView = require '../../views/items/experiment.coffee'

EmptyRowView = require '../../views/items/empty-row-view.coffee'

PagerView = require '../../views/pager.coffee'
PagerState = require '../../configurations/pager.coffee'

after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'Experiments'
  template: templates.pages.experiments.index

  initialize: () ->
    @.collection = new ExperimentsCollection()

  events:
    'click #newItem': 'newItem'
    'keyup [data-hook~=filter]': 'filterItems'

  subviews:
    subjects:
      hook: 'experiments-table'
      waitFor: 'collection'
      prepareView: (el) ->
        view = new CollectionView(el: el, collection: @.collection, view: ExperimentView, emptyView: EmptyRowView)
        do @.filterItems
        return view
    pager:
      hook: 'pagination-control'
      waitFor: 'collection'
      prepareView: (el) ->
        return new PagerView(model: new PagerState(collection: @.collection))

  newItem: () ->
    app.navigate('/experiments/create')

  filterItems: () ->
    @.collection.query @.queryByHook('filter').value