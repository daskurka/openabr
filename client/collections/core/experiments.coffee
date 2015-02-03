PagedCollection = require '../paged.coffee'
ExperimentModel = require '../../models/core/experiment.coffee'

module.exports = PagedCollection.extend
  model: ExperimentModel
  url: '/api/experiments'
  typeAttribute: 'experimentsCollection'

  query: (textSearch) ->
    data = {name: {$regex: "#{textSearch}", $options: 'i'} }
    @.queryPaged(1,15,data)