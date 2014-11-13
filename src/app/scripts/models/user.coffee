Base = require './base.coffee'

module.exports = Base.extend

  typeAttribute: 'userModel'
  urlRoot: '/api/profile'

  props:
    name: 'string'
    email: 'string'
    position: 'string'