View = require 'ampersand-view'
templates = require '../../templates'
_ = require 'lodash'
async = require 'async'

timeFormatter = (rawValue) ->
  value = rawValue / 1000
  return value.toFixed(2)
voltageFormatter = (rawValue) ->
  value = rawValue * 1000000
  return value.toFixed(2)

module.exports = View.extend

  template: templates.views.abrReadings.readingQueryRow

  bindings:
    'datePart': '[data-hook~=date]'
    'freqPart': '[data-hook~=freq]'
    'model.level': '[data-hook~=level]'
    'hasLatency':
      type: 'toggle'
      hook: 'latency'
    'joinedTags':
      hook: 'tags'
      type: 'innerHTML'
    'model.subjectId': '[data-hook~=subject]'
    'model.experiments': '[data-hook~=experiments]'
    'durationPart': '[data-hook~=duration]'
    'sampleRatePart': '[data-hook~=sampleRate]'
    'model.numberSamples': '[data-hook~=numberSamples]'
    'max': '[data-hook~=valueMax]'
    'min': '[data-hook~=valueMin]'

  render: () ->
    @.renderWithTemplate()

    #subject reference
    app.services.subject.lookupName @.model.subjectId, (err, result) =>
      @.queryByHook('subject').innerHTML = result

    #experiment lookup
    async.map @.model.experiments, app.services.experiment.lookupName, (err, result) =>
      html = ''
      for exp in result
        html += "<span class='label label-default'>#{exp}</span> "
      @.queryByHook('experiments').innerHTML = html

    return @

  derived:
    freqPart:
      deps: ['model.freq']
      fn: () -> return if @.model.freq? then (@.model.freq/1000) else "N/A"
    hasLatency:
      deps: ['model.analysis']
      fn: () -> if @.model.analysis? and @.model.analysis?.latency? then yes else no
    joinedTags:
      deps: ['model.tags']
      fn: () ->
        html = ''
        for tag in @.model.tags
          html += "<span class='label label-default'>#{tag}</span>"
        return html
    datePart:
      deps: ['model.date']
      fn: () -> @.model.date.toISOString().split('T')[0]
    durationPart:
      deps: ['model.duration']
      fn: () -> @.model.duration.toFixed(2)
    sampleRatePart:
      deps: ['model.sampleRate']
      fn: () -> @.model.sampleRate.toFixed(2)
    max:
      deps: ['valueMax']
      fn: () -> voltageFormatter(@.model.valueMax)
    min:
      deps: ['valueMin']
      fn: () -> voltageFormatter(@.model.valueMin)

  events:
    'click [data-hook~=reading-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.viewUrl)