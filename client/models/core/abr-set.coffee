Base = require '../base.coffee'
_ = require 'lodash'

AbrReadingsCollection = require '../../collections/core/abr-readings.coffee'

module.exports = Base.extend

  typeAttribute: 'abrSetModel'
  urlRoot: '/api/abr/sets'

  props:
    isClick: 'boolean'
    freq: 'number'

    analysis: 'object'
    fields: 'object'

    groupId: 'any' #link to group
    subjectId: 'any'  #link to subject

  session:
    selected: 'boolean'

  derived:
    maxLevel:
      deps: ['readings']
      fn: () ->_.max(@.readings.map (reading) -> reading.level)
    minLevel:
      deps: ['readings']
      fn: () -> _.min(@.readings.map (reading) -> reading.level)
    maxAmpl:
      deps: ['readings']
      fn: () -> _.max(@.readings.map (reading) -> reading.maxValue)
    minAmpl:
      deps: ['readings']
      fn: () -> _.min(@.readings.map (reading) -> reading.minValue)
    name:
      deps: ['maxLevel','minLevel','isClick','frequency']
      fn: () ->
        if @.isClick then return "Click #{@.maxLevel} dB - #{@.minLevel} dB"
        return "Tone #{@.maxLevel} dB - #{@.minLevel} dB @ #{@.frequency/1000} kHz"

  collections:
    readings: AbrReadingsCollection