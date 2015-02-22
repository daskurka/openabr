PageView = require '../base.coffee'
templates = require '../../templates'
async = require 'async'

AbrSetModel = require '../../models/core/abr-set.coffee'
DetailsCollection = require '../../collections/details-collection.coffee'

DetailListView = require '../../views/detail-list-view.coffee'
DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

module.exports = PageView.extend

  pageTitle: 'ABR Set View'
  template: templates.pages.abrSets.view

  initialize: (spec) ->
    model = new AbrSetModel(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

  events:
    'click [data-hook="edit"]': 'edit'
    'click [data-hook="remove"]': 'showRemove'

  showRemove: () ->
    app.navigate(@.model.removeUrl)

  edit: () ->
    app.navigate(@.model.editUrl)

  subviews:
    details:
      hook: 'details'
      waitFor: 'model'
      prepareView: (el) ->

        #subject specific
        col = new DetailsCollection()
        dataFields = new DataFieldsCollection()
        dataFields.loadFields 'abr-set', () =>
          fixedFields = new FixedDataFieldsCollection()
          fixedFields.addFixedFields 'abr-set'
          fixedFields.forEach (field) =>
            #if field.type is 'experiments' then return #subject specific, already showing this
            col.addField(field, @.model[field.dbName] ? null)
          if @.model.fields?
            dataFields.forEach (field) =>
              if field.dbName of @.model.fields
                col.addField(field, @.model.fields[field.dbName] ? null)

        return new DetailListView(el: el, collection: col)

