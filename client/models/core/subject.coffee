Base = require '../base.coffee'

module.exports = Base.extend

  typeAttribute: 'subjectModel'
  urlRoot: '/api/subjects'

  props:
    experiments: 'array' #[objectId]
    creator: 'any' #objectId
    created: 'date'
    reference: 'string'
    strain: 'string'
    species: 'string'
    dob: 'date'
    dod: 'date'
    fields: 'object'

  derived:
    editUrl:
      deps: ['id']
      fn: () -> "subjects/#{@.id}/edit"
    viewUrl:
      deps: ['id']
      fn: () -> "subjects/#{@.id}/view"
    removeUrl:
      deps: ['id']
      fn: () -> "subjects/#{@.id}/remove"