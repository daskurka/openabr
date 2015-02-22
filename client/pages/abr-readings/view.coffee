PageView = require '../base.coffee'
templates = require '../../templates'
async = require 'async'

AbrReadingModel = require '../../models/core/abr-reading.coffee'
DetailsCollection = require '../../collections/details-collection.coffee'

DetailListView = require '../../views/detail-list-view.coffee'
DataFieldsCollection = require '../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../collections/core/fixed-data-fields.coffee'

ReadingLatencyView = require '../../views/analysis/reading-latency.coffee'

module.exports = PageView.extend

  pageTitle: 'ABR Reading View'
  template: templates.pages.abrReadings.view

  initialize: (spec) ->
    model = new AbrReadingModel(id: spec.id)
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
    latency:
      hook: 'latency-analysis-area'
      waitFor: 'model'
      prepareView: (el) ->
        return new ReadingLatencyView(el: el, model: @.model, singleMode: yes)

    details:
      hook: 'details'
      waitFor: 'model'
      prepareView: (el) ->
        #subject specific
        col = new DetailsCollection()
        dataFields = new DataFieldsCollection()
        dataFields.loadFields 'abr-reading', () =>
          fixedFields = new FixedDataFieldsCollection()
          fixedFields.addFixedFields 'abr-reading'
          fixedFields.forEach (field) =>
            if field.type is 'values' then return #subject specific, already showing this
            col.addField(field, @.model[field.dbName] ? null)
          if @.model.fields?
            dataFields.forEach (field) =>
              if field.dbName of @.model.fields
                col.addField(field, @.model.fields[field.dbName] ? null)

        return new DetailListView(el: el, collection: col)