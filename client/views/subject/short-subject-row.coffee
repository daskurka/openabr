View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.views.subjects.shortSubjectRow

  initialize: () ->
    $.get '/api/abr/groups/count', {subjectId: @.model.id}, (groupData) =>
      groupCount = groupData.found
      $.get '/api/abr/readings/count', {subjectId: @.model.id}, (readingData) =>
        readingsCount = readingData.found

        @.abrDetails = "#{groupCount} Groups (#{readingsCount} Readings)"

  props:
    abrDetails: ['string',no,'-']

  derived:
    age:
      deps: ['model.dob','model.dod']
      fn: () ->
        current = if @.model.dod? and @.model.dod.getTime() isnt 0 then @.model.dod else Date.now()
        diff = current - @.model.dob.getTime()
        weeks = Math.ceil(diff / 604800000)
        return weeks
    isAlive:
      deps: ['model.dod']
      fn: () ->
        return not @.model.dod? or @.model.dod.getTime() is 0
    textDob:
      deps: ['model.dob','age','isAlive']
      fn: () ->
        datePart = @.model.dob.toISOString().split('T')[0]
        return if @.isAlive then "#{datePart} (#{@.age} weeks)" else "#{datePart}"
    textDod:
      deps: ['model.dod','age','isAlive']
      fn: () ->
        if @.isAlive
          return '—'
        else
          datePart = @.model.dod.toISOString().split('T')[0]
          return "#{datePart} (#{@.age} weeks)"

  bindings:
    'model.reference': '[data-hook~=reference]'
    'model.strain': '[data-hook~=strain]'
    'model.species': '[data-hook~=species]'
    'textDob': '[data-hook~=dob]'
    'textDod': '[data-hook~=dod]'
    'abrDetails': '[data-hook~=abr-details]'

  events:
    'click [data-hook~=subject-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.viewUrl)