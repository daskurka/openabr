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
    #abr-readings
    abrReadings = new AbrReadingCollection()
    abrReadings.on 'query:loaded', () =>
      models = abrReadings.models
      for model in models
        model.experiments = _.filter(model.experiments, (v) => v isnt @.model.id)
        do model.save
    abrReadings.query {experiments: @.model.id}

    #abr-sets
    abrSets = new AbrSetCollection()
    abrSets.on 'query:loaded', () =>
      models = abrSets.models
      for model in models
        model.experiments = _.filter(model.experiments, (v) => v isnt @.model.id)
        do model.save
    abrSets.query {experiments: @.model.id}

    #abr-groups
    abrGroups = new AbrGroupCollection()
    abrGroups.on 'query:loaded', () =>
      models = abrGroups.models
      for model in models
        model.experiments = _.filter(model.experiments, (v) => v isnt @.model.id)
        do model.save
    abrGroups.query {experiments: @.model.id}

    #subjects
    subjects = new SubjectCollection()
    subjects.on 'query:loaded', () =>
      models = subjects.models
      for model in models
        model.experiments = _.filter(model.experiments, (v) => v isnt @.model.id)
        do model.save
    subjects.query {experiments: @.model.id}

    #subject
    this.model.destroy
      success: () ->
        app.navigate('experiments')

  cancel: () ->
    app.navigate(@.model.viewUrl)