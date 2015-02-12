View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'

templates = require '../../templates'

ReadingListView = require '../../views/abr-reading/list.coffee'

module.exports = View.extend

  template: templates.views.abrGroups.show

  initialize: () ->
    #the model is a group, we need to turn it into a collection of ABR readings.
    @.model.getReadings (err, abrReadingCollection) =>
      @.collection = abrReadingCollection
      @.setCount = @.model.sets.length #now lazy loaded with above

  session:
    setCount: ['number',no,0]

  bindings:
    'model.name': '[data-hook~=title]'
    'model.date': '[data-hook~=subtitle]'
    'setCount': '[data-hook~=sets-count]'
    'collection.length': '[data-hook~=readings-count]'

  subviews:
    readingList:
      hook: 'readings-list'
      waitFor: 'collection'
      prepareView: (el) ->
        return new ReadingListView(el: el, collection: @.collection)