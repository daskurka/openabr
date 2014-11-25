Model = require 'ampersand-model'

module.exports = Model.extend

  idAttribute: 'id'

  typeAttribute: 'baseModel'

  props:
    id: 'any'

  ajaxConfig: () ->
    headers:
      token: app.serverToken