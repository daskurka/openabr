Base = require '../base.coffee'

module.exports = Base.extend

  typeAttribute: 'dataFieldModel'
  urlRoot: '/api/data-fields'

  props:
    col: 'string'
    type: 'string'
    name: 'string'
    dbName: 'string'
    description: 'string'
    required: 'boolean'
    creator: 'any' #objectId
    created: 'date'
    config: 'object'
    locked: 'boolean'
    autoPop: 'boolean'

  derived:
    editUrl:
      deps: ['col','dbName']
      fn: () -> "/admin/fields/#{@.col}/#{@.dbName}/edit"

  fetchByCollectionAndDbName: (col, dbName, callback) ->
    query = {col,dbName}
    $.get @.urlRoot, query, (data) =>
      if data.length > 0
        raw = data[0]
        @.set(raw)
        callback(null, @)
      else
        callback('Could not find matching data field.')