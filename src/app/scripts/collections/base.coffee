Collection = require 'ampersand-rest-collection'

module.exports = Collection.extend

  typeAttribute: 'baseCollection'
  ajaxConfig: () ->
    headers:
      token: app.serverToken