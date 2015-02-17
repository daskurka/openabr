State = require 'ampersand-state'

module.exports = State.extend

  session:
    type: 'string'#click or frequency in kHz
    level: 'number'

  derived:
    realLevel:
      deps: ['level']
      fn: () -> if @.level is 120 then 'No Response' else @.level