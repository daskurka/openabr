Collection = require 'ampersand-collection'

DetailModel = require '../models/detail-model.coffee'

module.exports = Collection.extend

  model: DetailModel

  addField: (ff, value) ->
    @.add
      type: ff.type
      name: ff.name
      dbName: ff.dbName
      required: ff.required
      config: ff.config
      value: value