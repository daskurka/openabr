State = require 'ampersand-state'

module.exports = State.extend

  props:
    data: 'object'

    mode: 'string' #subject, group, sets
    modeLocked: 'boolean'
    groupBy: 'string' #date-simple, age-monthly

    model: 'object' #subject, experiment or colletion sets

    graphWidth: 'number'
    graphHeight: 'number'
