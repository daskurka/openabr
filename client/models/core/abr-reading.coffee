State = require 'ampersand-state'

module.exports = State.extend

  typeAttribute: 'abrReadingModel'

  session:
    values: 'array'

  props:
    fields: 'object'
    freq: 'number'
    level: 'number'
    duration: 'number'
    sampleRate: 'number'
    numberSamples: 'number'
    valueMax: 'number'
    valueMin: 'number'
    valuesId: 'any' #objectId