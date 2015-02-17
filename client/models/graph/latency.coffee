State = require 'ampersand-state'

module.exports = State.extend

  props:
    data: 'object'

    graphWidth: 'number'
    graphHeight: 'number'