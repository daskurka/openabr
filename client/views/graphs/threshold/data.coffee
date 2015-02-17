View = require 'ampersand-view'
CollectionView = require 'ampersand-collection-view'

_ = require 'lodash'
saveAs = require 'browser-filesaver'

templates = require '../../../templates'

GroupDataRowModel = require './subviews/group-model.coffee'
GroupRowCollection = require './subviews/group-model-collection.coffee'
GroupRowView = require './subviews/group-row-view.coffee'

SingleDataRowModel = require './subviews/single-model.coffee'
SingleRowCollection = require './subviews/single-model-collection.coffee'
SingleRowView = require './subviews/single-row-view.coffee'

module.exports = View.extend

  template: templates.views.graphs.threshold.data

  session:
    rawDataCollection: 'object'
    dataView: 'any'

  events:
    'click [data-hook~=export-csv]': 'exportCSV'
    'click [data-hook~=export-json]': 'exportJSON'

  initialize: () ->
    #we need to put all the data into a single giant array that can be tabulated.

    collection = null

    if @.model.mode is 'group'
      collection = new SingleRowCollection()
      @.dataView = SingleRowView

      for value in @.model.data
        collection.add new SingleDataRowModel
          type: if value.freq? then "#{parseInt(value.freq) / 1000}" else 'Click'
          level: value.level

    else
      collection = new GroupRowCollection()
      @.dataView = GroupRowView

      #TODO: fix the cause of this (upload not saving date likely)
      groups = _.filter(@.model.data.groups, (g) -> return g isnt '1970-01-01')

      switch @.model.groupBy
        when 'date-simple'
          for group in groups
            if @.model.data.toneData[group]?
              for key of @.model.data.toneData[group]
                collection.add new GroupDataRowModel
                  group: group
                  groupActual: group
                  type: "#{parseInt(key) / 1000}"
                  level: @.model.data.toneData[group][key][0]
            if @.model.data.clickData[group]?
              collection.add new GroupDataRowModel
                group: group
                groupActual: group
                type: 'Click'
                level: @.model.data.clickData[group][0]

    @.rawDataCollection = collection

  render: () ->
    @.renderWithTemplate()

    switch @.model.mode
      when 'group'
        @.queryByHook('table-headers').innerHTML = "<th>Type</th><th>Level (dB)</th>"
      else
        @.queryByHook('table-headers').innerHTML = "<th>Group</th><th>Real Value</th><th>Type</th><th>Level (dB)</th>"

    return @

  getFileName: (ending) ->
    date = new Date().toISOString().split('T')[0]
    if @.model.mode is 'subject'
      return "#{date}-#{@.model.model.reference}-#{@.model.model.strain}-threshold-graph-raw-data.#{ending}"
    else
      alert 'not implemented' #todo this...

  exportJSON: () ->
    jsonString = @.rawDataCollection.exportJSON()
    blob = new Blob([jsonString],{type: "text/plain;charset=utf-8"})
    saveAs(blob, @.getFileName('json'))

  exportCSV: () ->
    csvString = @.rawDataCollection.exportCSV()
    blob = new Blob([csvString],{type: "text/plain;charset=utf-8"})
    saveAs(blob, @.getFileName('csv'))

  subviews:
    rawData:
      hook: 'raw-data-table'
      waitFor: 'rawDataCollection'
      prepareView: (el) ->
        return new CollectionView(el: el, collection: @.rawDataCollection, view: @.dataView)

