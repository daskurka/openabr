PagedCollection = require '../paged.coffee'
Subject = require '../../models/core/subject.coffee'

module.exports = PagedCollection.extend
  model: Subject
  url: '/api/subjects'
  typeAttribute: 'subjectsCollection'

  query: (textSearch) ->
    data = {reference: {$regex: "#{textSearch}", $options: 'i'} }
    @.queryPaged(1,15,data)