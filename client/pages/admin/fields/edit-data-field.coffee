PageView = require '../../base.coffee'
templates = require '../../../templates'
DataFieldForm = require '../../../forms/data-field.coffee'
ConfirmView = require '../../../views/confirm.coffee'
ConfirmModel = require '../../../models/confirm.coffee'
DataField = require '../../../models/core/data-field.coffee'

module.exports = PageView.extend

  pageTitle: 'Edit Data Field'
  template: templates.pages.admin.fields.editDataField

  events:
    'click [data-hook="cancel"]': 'cancel'

  cancel: () ->
    app.navigate('admin/fields/' + @.colName)

  initialize: (spec) ->
    @.colName = spec.col
    @.dbName = spec.dbName

    #load model
    model = new DataField()
    model.fetchByCollectionAndDbName spec.col, spec.dbName, () =>
      @.model = model

  props:
    colName: 'string'

  derived:
    collectionName:
      deps: ['colName']
      fn: () -> asCollectionName(@.colName)

  bindings:
    'collectionName': '[data-hook=collection-name]'

  removeField: () ->
    #todo: only delete if no usages
    colName = @.colName
    @.model.destroy
      success: () -> app.navigate('admin/fields/' + colName)

  subviews:
    deleteConfirm:
      hook: 'delete-confirm'
      waitFor: 'model'
      prepareView: (el) ->
        model = new ConfirmModel
          message: 'Delete this data field?'
          button: 'Delete'
        return new ConfirmView
          el: el
          model: model
          action: () => @.removeField()
    form:
      container: 'form'
      waitFor: 'model'
      prepareView: (el) ->
        model = @.model
        return new DataFieldForm
          el: el
          model: @.model
          data: {colName: @.colName}
          submitCallback: (data) =>
            if model.dbName isnt data.dbName
              #todo: allow changing or updating of dbName
              alert('Cannot at this change dbName, please wait for a future release or bug a developer')
              return
            delete data.dbName

            #handle number
            if data.type is 'number'
              if not data.config?
                data.config = {}
              data.config.prefix = data.prefix
              data.config.unit = data.unit
            delete data.prefix
            delete data.unit

            model.set data
            model.save null,
              wait: yes
              success: () =>
                app.navigate('admin/fields/' + @.colName)

  asCollectionName = (colName) ->
    switch colName
      when 'subject' then return 'Subject'
      when 'experiment' then return 'Experiment'
      when 'abr' then return 'ABR'
      when 'abr-group' then return 'ABR Group'
      when 'abr-set' then return 'ABR Set'
      when 'abr-reading' then return 'ABR Reading'