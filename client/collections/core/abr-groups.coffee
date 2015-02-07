PagedCollection = require '../paged.coffee'
AbrGroup = require '../../models/core/abr-group.coffee'

module.exports = PagedCollection.extend
  model: AbrGroup
  url: '/api/abr/groups'
  typeAttribute: 'abrGroupsCollection'