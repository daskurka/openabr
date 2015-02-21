View = require 'ampersand-view'
templates = require '../../templates'
select2 = require 'select2'

AbrReadingCollection = require '../../collections/core/abr-readings.coffee'
AbrSetCollection = require '../../collections/core/abr-sets.coffee'
AbrGroupCollection = require '../../collections/core/abr-groups.coffee'

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

  updateExperimentsForCollection = (collection, experiments) ->
    collection.each (item) ->
      item.experiments = experiments
      do item.save

  handleInputChanged: (event) ->
    @.model.experiments = event.val
    @.model.save null,
      success: (subject) ->
        abrGroups = new AbrGroupCollection()
        abrGroups.on 'query:loaded', () -> updateExperimentsForCollection(abrGroups, event.val)
        abrGroups.query {subjectId: subject.id}

        abrSets = new AbrSetCollection()
        abrSets.on 'query:loaded', () -> updateExperimentsForCollection(abrSets, event.val)
        abrSets.query {subjectId: subject.id}

        abrReadings = new AbrReadingCollection()
        abrReadings.on 'query:loaded', () -> updateExperimentsForCollection(abrReadings, event.val)
        abrReadings.query {subjectId: subject.id}
