Model = require 'ampersand-model'

module.exports = Model.extend

  typeAttribute: 'baseModel'
  ajaxConfig: () ->
    headers:
      token: app.serverToken