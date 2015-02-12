View = require 'ampersand-view'
templates = require '../../templates'
_ = require 'lodash'

timeFormatter = (rawValue) ->
  value = rawValue / 1000
  return value.toFixed(2)
voltageFormatter = (rawValue) ->
  value = rawValue * 1000000
  return value.toFixed(2)

module.exports = View.extend

  template: templates.views.abrReadings.readingRow

  bindings:
    'freqPart': '[data-hook~=freq]'
    'model.level': '[data-hook~=level]'
    'latency1': '[data-hook~=latency1]'
    'latency2': '[data-hook~=latency2]'
    'latency3': '[data-hook~=latency3]'
    'latency4': '[data-hook~=latency4]'
    'latency5': '[data-hook~=latency5]'

  generateLatencyText = (peakNumber, analysis) ->
    if analysis? and analysis.latency? and analysis.latency.peaks?
      peak = _.first(analysis.latency.peaks, (pk) -> pk.number is peakNumber)[0]
      if peak? and peak.peakAmpl? and peak.peakTime?
        return "#{voltageFormatter(peak.peakAmpl)} µV @ #{timeFormatter(peak.peakTime)} ms"
      else
        return 'Not Found'
    else
      return '-'

  derived:
    freqPart:
      deps: ['model.freq']
      fn: () -> return if @.freq? then (@.freq/1000) else "N/A"
    latency1:
      deps: ['model.analysis']
      fn: () -> return generateLatencyText(1, @.model.analysis)
    latency2:
      deps: ['model.analysis']
      fn: () -> return generateLatencyText(2, @.model.analysis)
    latency3:
      deps: ['model.analysis']
      fn: () -> return generateLatencyText(3, @.model.analysis)
    latency4:
      deps: ['model.analysis']
      fn: () -> return generateLatencyText(4, @.model.analysis)
    latency5:
      deps: ['model.analysis']
      fn: () -> return generateLatencyText(5, @.model.analysis)

  events:
    'click [data-hook~=reading-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.editUrl)