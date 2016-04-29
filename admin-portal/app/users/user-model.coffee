BaseModel = require '../base-model'


module.exports = BaseModel.extend

  baseUrl: "/admin/data/_users"

  props:
    name: 'string'
    title: 'string'
    roles: 'array'
    openabr: 'boolean'

    derived_key: 'string'
    iterations: 'number'
    password_scheme: 'string'
    salt: 'string'
    type: 'string'

  derived:
    couchRoles:
      deps: ['roles']
      fn: () ->
        console.log @._values
        return @.roles.join(', ')
