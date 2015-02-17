State = require 'ampersand-state'

module.exports = State.extend

  props:
    data: 'object'

    mode: 'string' #subject, group, experiment
    modeLocked: 'boolean'
    groupBy: 'string' #date-simple

    model: 'object' #subject, experiment or other model

    graphWidth: 'number'
    graphHeight: 'number'
