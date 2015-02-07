View = require 'ampersand-view'
State = require 'ampersand-state'
templates = require '../../templates'
select2 = require 'select2'

ExperimentsState = State.extend
  props:
    experiments: 'array'

module.exports = View.extend

  template: templates.views.subjects.selectSubjectExperiments

  url: '/api/experiments'

  props:
    experiments: 'array'

  initialize: () ->
    @.model = new ExperimentsState(experiments: [])
    @.parent.on 'subject-selector:subject:selected', (subject) =>
      @.model.experiments = subject.experiments
      $(@.input).select2('val', '')
      if subject.experiments.length > 0
        @.loadExperimentsFromObjectIdArray @.model.experiments, (results) =>
          $(@.input).select2('data', results)

  render: () ->
    do @.renderWithTemplate

    config =
      placeholder: 'Select one or more experiments for these ABR recordings...'
      multiple: true
      ajax:
        url: @.url
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> return {name: {$regex: "#{term}", $options: 'i'} }
        results: (experiments, page) ->
          results = []
          for exp in experiments
            results.push {id: exp.id, text: exp.name}
          return {results: results}
        cache: true
      initSelection: (element, callback) =>
        arr = element[0].value
        experimentIds = arr.split(',')
        @.loadExperimentsFromObjectIdArray(experimentIds, callback)

    @.input = @.query('input')

    $(@.input).select2(config)
    $(@.input).on 'change', (event) => @.handleInputChanged(event)

    return @

  handleInputChanged: (event) ->
    @.experiments = event.val

  loadExperimentsFromObjectIdArray: (array, callback) ->
    query = {_id: {$in: array}}
    $.get @.url, query, (response) ->
      results = []
      for experiment in response
        results.push {id: experiment.id, text: experiment.name}
      callback(results)
