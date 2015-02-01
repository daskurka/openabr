State = require 'ampersand-state'


module.exports = State.extend

  props:
    type: 'string'
    name: 'string'
    dbName: 'string'
    required: 'boolean'
    config: 'object'