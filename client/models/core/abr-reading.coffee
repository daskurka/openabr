Base = require '../base.coffee'

SubjectModel = require './subject.coffee'
SetModel = require './abr-set.coffee'

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
    date: 'date' #duplicate of group date for faster searching

    tags: ['array', no, () -> []]

  session:
    selected: ['boolean', no, no]
    subject: 'object'
    abrSet: 'object'

  derived:
    editUrl:
      deps: ['id']
      fn: () -> "abr/readings/#{@.id}/edit"
    viewUrl:
      deps: ['id']
      fn: () -> "abr/readings/#{@.id}/view"
    name:
      deps: ['freq','level']
      fn: () ->
        return if @.freq? then "Tone - #{@.level} dB @ #{@freq/1000} kHz" else "Click - #{@.level} dB"
    nameHtml:
      deps: ['freq','level','readings']
      fn: () ->
        if @.freq?
          return "Tone - <strong>#{@.level}</strong> dB @ <strong>#{@.freq/1000}</strong> kHz"
        else
          return "Click - <strong>#{@.level}</strong> dB"
    imageFilename:
      deps: ['freq','level','subjectId']
      fn: () ->
        todayDate = new Date().toISOString().split('T')[0]
        type = if @.freq? then 'tone' else 'click'
        return "#{todayDate}_#{@.subjectId}_#{type}_#{@.freq}Hz_#{@.level}dB"

  lazyLoadSubject: (cb) ->
    if @.subject? then return cb(null, @.subject)
    @.subject = new SubjectModel(id: @.subjectId)
    @.subject.fetch
      success: () ->
        cb(null, @.subject)

  lazyLoadSet: (cb) ->
    if @.abrSet? then return cb(null, @.abrSet)
    @.abrSet = new AbrSetModel(id: @.setId)
    @.abrSet.fetch
      success: () ->
        cb(null, @.abrSet)