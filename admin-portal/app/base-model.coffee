Model = require 'ampersand-model'

module.exports = Model.extend

  idAttribute: '_id'
  userRoot: App.baseUrl + "/data"

  props:
    _id: 'string'
    _rev: 'string'
    _attachments: 'object'
