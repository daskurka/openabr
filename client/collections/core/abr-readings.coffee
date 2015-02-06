Collection = require 'ampersand-collection'
AbrReading = require '../../models/core/abr-reading.coffee'

module.exports = Collection.extend
  model: AbrReading
  typeAttribute: 'abrReadingsCollection'