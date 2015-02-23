PageView = require '../../base.coffee'
templates = require '../../../templates'
DataFieldForm = require '../../../forms/data-field.coffee'
ConfirmView = require '../../../views/confirm.coffee'
ConfirmModel = require '../../../models/confirm.coffee'
DataField = require '../../../models/core/data-field.coffee'
FieldCollection = require '../../../collections/core/data-fields.coffee'

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
    #TODO, add option for thin delete (just remove this reference but leave data) or deep delete (this reference and data)
    colName = @.colName
    #speical condition, add for abr-reading, abr-group, abr-set adds for all
    switch colName
      when 'abr-reading','abr-set','abr-group'
        abrFields = new FieldCollection()
        abrFields.queryDbName @.dbName, () =>
          fields = abrFields.models #todo: figure out what on eartht is going on here and why i cannot iterate correctly.
          one = fields[0] ? null
          two = fields[1] ? null
          three = fields[2] ? null
          one.destroy
            success: () -> two.destroy
              success: () -> three.destroy
                success: () ->
                  app.navigate('admin/fields/' + colName)
      else
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

            #speical condition, add for abr-reading, abr-group, abr-set adds for all
            switch @.colName
              when 'abr-reading','abr-set','abr-group'
                abrFields = new FieldCollection()
                abrFields.queryDbName @.dbName, () =>
                  fields = abrFields.models #todo: figure out what on earth is going on here and why i cannot iterate correctly.
                  one = fields[0] ? null
                  one.set data
                  two = fields[1] ? null
                  two.set data
                  three = fields[2] ? null
                  three.set data
                  one.save null,
                    success: () => two.save null,
                      success: () => three.save null,
                        success: () =>
                          app.navigate('admin/fields/' + @.colName)
              else
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