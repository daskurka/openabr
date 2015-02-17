Collection = require 'ampersand-collection'
ThresholdGroupDataRowModel = require './group-model.coffee'

module.exports = Collection.extend

  model: ThresholdGroupDataRowModel

  exportJSON: () ->
    data = []
    @.each (rawRow) ->
      data.push
        group: rawRow.group
        groupActual: rawRow.groupActual
        type: rawRow.type
        level: rawRow.realLevel
    return JSON.stringify(data)

  exportCSV: () ->
    csvString = "group,groupActual,type,level#{String.fromCharCode(13)}"
    @.each (rawRow) ->
      csvString += "#{rawRow.group},#{rawRow.groupActual},#{rawRow.type},#{rawRow.realLevel}#{String.fromCharCode(13)}"

    return csvString