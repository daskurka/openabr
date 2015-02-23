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

  template: templates.views.abrSets.setQueryRow

  bindings:
    'datePart': '[data-hook~=date]'
    'freqPart': '[data-hook~=freq]'
    'joinedTags':
      hook: 'tags'
      type: 'innerHTML'
    'thresholdPart': '[data-hook~=threshold]'
    'typePart': '[data-hook~=type]'

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
    thresholdPart:
      deps: ['model.analysis']
      fn: () ->
        if @.model.analysis? and @.model.analysis.threshold?
          threshold = @.model.analysis.threshold
          return "#{threshold.level} dB - #{threshold.method}"
        else
          return "-"
    typePart:
      deps: ['model.isClick']
      fn: () -> if @.model.isClick then "Click" else "Tone"

  events:
    'click [data-hook~=set-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.viewUrl)