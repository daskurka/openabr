PagedCollection = require '../paged.coffee'
AbrReading = require '../../models/core/abr-reading.coffee'

module.exports = PagedCollection.extend
  model: AbrReading
  url: '/api/abr/readings'
  typeAttribute: 'abrReadingsCollection'