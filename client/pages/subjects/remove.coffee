PageView = require '../base.coffee'
templates = require '../../templates'

async = require 'async'

SubjectModel = require '../../models/core/subject.coffee'

AbrGroupCollection = require '../../collections/core/abr-groups.coffee'
AbrSetCollection = require '../../collections/core/abr-sets.coffee'
AbrReadingCollection = require '../../collections/core/abr-readings.coffee'

module.exports = PageView.extend

  pageTitle: 'Remove Subject'
  template: templates.pages.subjects.remove

  initialize: (spec) ->
    model = new SubjectModel(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

  derived:
    title:
      deps: ['model.reference']
      fn: () ->
        if not @.model? then return 'loading...'
        return "Remove Subject: #{@.model.reference}"
    age:
      deps: ['model.dob','model.dod']
      fn: () ->
        current = if @.model.dod? and @.model.dod.getTime() isnt 0 then @.model.dod else Date.now()
        diff = current - @.model.dob.getTime()
        weeks = Math.ceil(diff / 604800000)
        return weeks
    subtitle:
      deps: ['model','model.species','model.strain','age','model.dod']
      fn: () ->
        if not @.model? then return 'loading...'
        agePart = if @.model.dod? and @.model.dod.getTime() isnt 0 then "(lived #{@.age} weeks)" else "(#{@.age} weeks old)"
        return "#{@.model.strain} #{@.model.species} #{agePart}"

  bindings:
    'title': '[data-hook~=title]'
    'subtitle': '[data-hook~=subtitle]'

  events:
    'click [data-hook~=remove]': 'removeSubject'
    'click [data-hook~=cancel]': 'cancel'

  removeSubject: () ->
    #abr-readings
    abrReadings = new AbrReadingCollection()
    abrReadings.on 'query:loaded', () =>
      models = abrReadings.models
      for model in models
        do model.destroy
    abrReadings.query {subjectId: @.model.id}

    #abr-sets
    abrSets = new AbrSetCollection()
    abrSets.on 'query:loaded', () =>
      models = abrSets.models
      for model in models
        do model.destroy
    abrSets.query {subjectId: @.model.id}

    #abr-groups
    abrGroups = new AbrGroupCollection()
    abrGroups.on 'query:loaded', () =>
      models = abrGroups.models
      for model in models
        do model.destroy
    abrGroups.query {subjectId: @.model.id}

    #subject
    this.model.destroy
      success: () ->
        app.navigate('subjects')

  cancel: () ->
    app.navigate(@.model.viewUrl)