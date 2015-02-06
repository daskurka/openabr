View = require 'ampersand-view'
CollectionView = require 'ampersand-collection-view'

templates = require '../../templates'

SetView = require './set-view.coffee'

module.exports = View.extend

  template: templates.views.upload.groupView

  bindings:
    'model.number': '[data-hook~=group-number]'
    'model.name': '[data-hook~=sub-name]'

  subviews:
    sets:
      hook: 'sets-area'
      waitFor: 'model'
      prepareView: (el) ->
        return new CollectionView(el: el, collection: @.model.sets, view: SetView)
