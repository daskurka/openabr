PagedCollection = require '../paged.coffee'
AbrSet = require '../../models/core/abr-set.coffee'

module.exports = PagedCollection.extend
  model: AbrSet
  url: '/api/abr/sets'
  typeAttribute: 'abrSetsCollection'