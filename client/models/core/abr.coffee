Base = require '../base.coffee'
AbrGroupsCollection = require '../../collections/core/abr-groups.coffee'

module.exports = Base.extend

  typeAttribute: 'abrModel'
  urlRoot: '/api/abrs'

  props:
    state: 'string'
    experiments: 'array'
    creator: 'any'
    created: 'date'
    subject:
      id: 'any' #objectId
      reference: 'string'
      strain: 'string'
      species: 'string'
    fields: 'object'
    date: 'date'
    source: 'string' #source of this abr record
    fields: 'object'

  collections:
    groups: AbrGroupsCollection

  derived:
    editUrl:
      deps: ['id']
      fn: () -> "abrs/#{@.id}/edit"
    viewUrl:
      deps: ['id']
      fn: () -> "abrs/#{@.id}/view"