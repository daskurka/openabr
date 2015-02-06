Collection = require 'ampersand-collection'
AbrSet = require '../../models/core/abr-set.coffee'

module.exports = Collection.extend
  model: AbrSet
  typeAttribute: 'abrSetsCollection'