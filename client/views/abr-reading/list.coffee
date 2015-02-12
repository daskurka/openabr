View = require 'ampersand-view'
templates = require '../../templates'

CollectionView = require 'ampersand-collection-view'
AbrReadingRowView = require '../abr-reading/abr-reading-row.coffee'

module.exports = View.extend

  template: templates.views.abrReadings.list

  subviews:
    list:
      hook: 'reading-list'
      waitFor: 'collection'
      prepareView: (el) ->
        return new CollectionView
          el: el
          collection: @.collection
          view: AbrReadingRowView
