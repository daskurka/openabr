View = require 'ampersand-view'
templates = require '../../templates'
select2 = require 'select2'

module.exports = View.extend

  template: templates.views.subjects.selectSubjectExperiments

  url: '/api/experiments'

  render: () ->
    do @.renderWithTemplate

    config =
      placeholder: 'Assign this subject to one or more experiments...'
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
        userIds = arr.split(',')
        query = {_id: {$in: userIds}}
        $.get @.url, query, (response) ->
          results = []
          for user in response
            results.push {id: user.id, text: user.name}
          callback(results)

    @.input = @.query('input')

    $(@.input).select2(config)
    $(@.input).on 'change', (event) => @.handleInputChanged(event)

    return @

  handleInputChanged: (event) ->
    @.model.experiments = event.val
    do @.model.save