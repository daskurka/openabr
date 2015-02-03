View = require 'ampersand-view'
CollectionView = require 'ampersand-collection-view'

DetailListItemView = require './items/detail-list-item.coffee'

module.exports = View.extend

  template: "<table class='table table-condensed'><tbody data-hook='details-list'></tbody></table>"

  subviews:
    details:
      hook: 'details-list'
      waitFor: 'collection'
      prepareView: (el) ->
        return new CollectionView(el: el, collection: @.collection, view: DetailListItemView)
