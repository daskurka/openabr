State = require 'ampersand-state'

module.exports = State.extend

  typeAttribute: 'fixedDataFieldModel'

  props:
    col: 'string'
    type: 'string'
    name: 'string'
    dbName: 'string'
    autoPop: 'boolean'
    description: 'string'
    required: 'boolean'
    config: 'object'

  derived:
    id:
      deps: ['col','type']
      fn: () -> "#{@.col}_#{@.dbName}"