Collection = require 'ampersand-collection'
AbrGroup = require '../../models/core/abr-group.coffee'

module.exports = Collection.extend
  model: AbrGroup
  typeAttribute: 'abrGroupsCollection'