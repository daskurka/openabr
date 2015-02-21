PageView = require '../base.coffee'
templates = require '../../templates'

_ = require 'lodash'

ExperimentModel = require '../../models/core/experiment.coffee'

AbrGroupCollection = require '../../collections/core/abr-groups.coffee'
AbrSetCollection = require '../../collections/core/abr-sets.coffee'
AbrReadingCollection = require '../../collections/core/abr-readings.coffee'
SubjectCollection = require '../../collections/core/subjects.coffee'

module.exports = PageView.extend

  pageTitle: 'Remove Experiment'
  template: templates.pages.experiments.remove

  initialize: (spec) ->
    model = new ExperimentModel(id: spec.id)
    model.fetch
      success: (model) =>
        @.model = model

  derived:
    title:
      deps: ['model.name']
      fn: () ->
        if not @.model? then return 'loading...'
        return "Remove Experiment: #{@.model.name}"

  props:
    subtitle: ['string',no,'']

  bindings:
    'title': '[data-hook~=title]'
    'subtitle': '[data-hook~=subtitle]'

  events:
    'click [data-hook~=remove]': 'removeExperiment'
    'click [data-hook~=cancel]': 'cancel'

  removeExperiment: () ->

    removeFromCollection = (collection, experimentId) ->
      collection.each (item) ->
        item.experiments = _.filter(item.experiments, (id) -> id isnt experimentId)
        do item.save

    #abr-readings
    abrReadings = new AbrReadingCollection()
    abrReadings.on 'query:loaded', () => removeFromCollection(abrReadings, @.model.id)
    abrReadings.query {experiments: @.model.id}

    #abr-sets
    abrSets = new AbrSetCollection()
    abrSets.on 'query:loaded', () => removeFromCollection(abrSets, @.model.id)
    abrSets.query {experiments: @.model.id}

    #abr-groups
    abrGroups = new AbrGroupCollection()
    abrGroups.on 'query:loaded', () => removeFromCollection(abrGroups, @.model.id)
    abrGroups.query {experiments: @.model.id}

    #subjects
    subjects = new SubjectCollection()
    subjects.on 'query:loaded', () => removeFromCollection(subjects, @.model.id)
    subjects.query {experiments: @.model.id}

    #subject
    this.model.destroy
      success: () ->
        app.navigate('experiments')

  cancel: () ->
    app.navigate(@.model.viewUrl)