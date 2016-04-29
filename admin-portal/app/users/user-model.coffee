BaseModel = require '../base-model'


module.exports = BaseModel.extend

  urlRoot: App.baseUrl + "/data/_users"

  props:
    name: 'string'
    title: 'string'
    roles: 'array'    
    userType: 'string'

    derived_key: 'string'
    iterations: 'number'
    password_scheme: 'string'
    salt: 'string'
    type: 'string'

  derived:
    couchRoles:
      deps: ['roles']
      fn: () -> return @.roles.join(', ')
