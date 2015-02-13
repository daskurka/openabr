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
    experiments: 'array' #objectId link to experiments

    tags: ['array', no, () -> []]

  session:
    selected: 'boolean'
    abrGroup: 'object'

  derived:
    maxLevel:
      deps: ['readings']
      fn: () -> return _.max(@.readings.map (reading) -> reading.level)
    minLevel:
      deps: ['readings']
      fn: () -> _.min(@.readings.map (reading) -> reading.level)
    maxAmpl:
      deps: ['readings']
      fn: () -> _.max(@.readings.map (reading) -> reading.valueMax)
    minAmpl:
      deps: ['readings']
      fn: () -> _.min(@.readings.map (reading) -> reading.valueMin)
    name:
      deps: ['maxLevel','minLevel','isClick','frequency']
      fn: () ->
        if @.isClick then return "Click #{@.maxLevel} dB - #{@.minLevel} dB"
        return "Tone #{@.maxLevel} dB - #{@.minLevel} dB @ #{@.freq/1000} kHz"
    nameHtml:
      deps: ['freq','isClick','readings']
      fn: () ->
        if @.isClick
          return "Click - <strong>#{@.readings.length}</strong> readings"
        else
          return "Tone - <strong>#{@.readings.length}</strong> readings @ <strong>#{@.freq/1000}</strong> kHz"

  collections:
    readings: AbrReadingsCollection

  quicksave: (callbacks) ->
    tempReadings = @.readings
    @.readings = new AbrReadingsCollection()
    @.save null,
      success: (model, xhr, options) ->
        model.readings = tempReadings
        callbacks.success(model,xhr,options)
      error: (model, xhr, options) ->
        model.readings = tempReadings
        callback.error(model,xhr,options)

  lazyLoadReadings: (callback) ->
    @.readings = new AbrReadingsCollection()
    @.readings.on 'query:loaded', () =>
      @.readings.each (reading) => reading.abrSet = @
      callback()
    @.readings.query {setId: @.id}