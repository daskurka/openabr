State = require 'ampersand-state'
_ = require 'lodash'
AbrReadingsCollection = require '../../collections/core/abr-readings.coffee'

module.exports = State.extend

  typeAttribute: 'abrSetModel'

  props:
    fields: 'object'
    isClick: 'boolean'
    frequency: 'number'

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