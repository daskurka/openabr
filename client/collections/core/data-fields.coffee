BaseCollection = require '../base.coffee'
DataField = require '../../models/core/data-field.coffee'

module.exports = BaseCollection.extend
  model: DataField
  url: '/api/data-fields'
  typeAttribute: 'dataFieldCollection'

  loadFields: (collectionName, callback) ->
    @.fetch
      data: {col: collectionName}
      success: (collection, response, options) -> callback(null)
      error: (collection, response, options) ->
        if response.status is 401 then app.logout()
