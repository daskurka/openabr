PageView = require '../../base.coffee'
templates = require '../../../templates'
DataFieldForm = require '../../../forms/data-field.coffee'
DataField = require '../../../models/core/data-field.coffee'

async = require 'async'

module.exports = PageView.extend

  pageTitle: 'Create Data Field'
  template: templates.pages.admin.fields.createDataField

  events:
    'click [data-hook="cancel"]': 'cancel'

  prop:
    colName: 'string'

  derived:
    collectionName:
      deps: ['colName']
      fn: () -> asCollectionName(@.colName)

  initialize: (spec) ->
    @.colName = spec.col

  bindings:
    'collectionName': '[data-hook=collection-name]'

  cancel: () ->
    app.navigate('admin/fields/' + @.colName)

  subviews:
    form:
      container: 'form'
      waitFor: 'colName'
      prepareView: (el) ->
        return new DataFieldForm
          el: el
          data: {colName: @.colName}
          submitCallback: (data) =>
            data.config = {}
            data.col = @.colName
            data.creator = app.me.user.id
            data.created = new Date()
            data.locked = false
            data.autoPop = false

            #handle number
            if data.type is 'number'
              data.config.prefix = data.prefix
              data.config.unit = data.unit
            delete data.prefix
            delete data.unit

            #speical condition, add for abr-reading, abr-group, abr-set adds for all
            switch @.colName
              when 'abr-reading','abr-set','abr-group'
                async.parallel [
                  (cb) ->
                    reading = data
                    reading.col = 'abr-reading'
                    newField = new DataField(reading)
                    newField.save reading,
                      success: () -> do cb
                ,
                  (cb) ->
                    group = data
                    group.col = 'abr-group'
                    newField = new DataField(group)
                    newField.save group,
                      success: () -> do cb
                ,
                  (cb) ->
                    set = data
                    set.col = 'abr-set'
                    newField = new DataField(set)
                    newField.save set,
                      success: () -> do cb
                ], (err) =>
                  if err? then return console.log 'Error: ' + err
                  app.navigate('admin/fields/' + @.colName )
              else
                newField = new DataField(data)
                newField.save data,
                  success: () ->
                    app.navigate('admin/fields/' + data.col)

  asCollectionName = (colName) ->
    switch colName
      when 'subject' then return 'Subject'
      when 'experiment' then return 'Experiment'
      when 'abr' then return 'ABR'
      when 'abr-group' then return 'ABR Group'
      when 'abr-set' then return 'ABR Set'
      when 'abr-reading' then return 'ABR Reading'