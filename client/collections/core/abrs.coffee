PagedCollection = require '../paged.coffee'
Abr = require '../../models/core/abr.coffee'

module.exports = PagedCollection.extend
  model: Abr
  url: '/api/abrs'
  typeAttribute: 'abrsCollection'