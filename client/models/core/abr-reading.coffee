Base = require '../base.coffee'

module.exports = Base.extend

  typeAttribute: 'abrReadingModel'
  urlRoot: '/api/abr/readings'

  props:
    freq: 'number'
    level: 'number'
    duration: 'number'
    sampleRate: 'number'
    numberSamples: 'number'

    valueMax: 'number'
    valueMin: 'number'
    values: 'array'

    analysis: 'object'
    fields: 'object'

    setId: 'any' #link to set
    subjectId: 'any'  #link to subject
    experiments: 'array' #objectId link to experiments