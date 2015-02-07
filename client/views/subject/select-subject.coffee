View = require 'ampersand-view'
templates = require '../../templates'
select2 = require 'select2'
SubjectModel = require '../../models/core/subject.coffee'

module.exports = View.extend

  template: templates.views.subjects.selectSubject

  url: '/api/subjects'

  props:
    subject: 'object'

  events:
    'click [data-hook~=create-subject]': 'createSubject'

  render: () ->
    @.renderWithTemplate()

    config =
      placeholder: 'You must select a subject...'
      multiple: no
      ajax:
        url: @.url
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> return {reference: {$regex: "#{term}", $options: 'i'} }
        results: (subjects, page) ->
          results = []
          for subject in subjects
            results.push {id: subject.id, text: subject.reference, value: subject}
          return {results: results}
        cache: true
      initSelection: (element, callback) =>
        id = element[0].value
        console.log id
        query = {_id: id}
        $.get @.url, query, (response) ->
          console.log response
          results = []
          for subject in response
            results.push {id: subject.id, text: subject.reference, value: subject}
          callback(results[0])

    @.input = @.query('input')

    $(@.input).select2(config)
    $(@.input).on 'change', (event) => @.handleInputChanged(event)

    return @

  handleInputChanged: (event) ->
    @.subject = new SubjectModel(event.added.value)
    @.trigger 'subject:selected', @.subject

  createSubject: () ->
    @.trigger 'create:subject'