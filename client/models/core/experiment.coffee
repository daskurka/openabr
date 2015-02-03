Base = require '../base.coffee'

module.exports = Base.extend

  typeAttribute: 'experimentModel'
  urlRoot: '/api/experiments'

  props:
    name: 'string' #[objectId]
    description: 'string' #objectId
    creator: 'any'
    created: 'date'
    fields: 'object'

  derived:
    editUrl:
      deps: ['id']
      fn: () -> "experiments/#{@.id}/edit"
    viewUrl:
      deps: ['id']
      fn: () -> "experiments/#{@.id}/view"