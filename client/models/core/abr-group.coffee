Base = require '../base.coffee'
_ = require 'lodash'

async = require 'async'

AbrSetsCollection = require '../../collections/core/abr-sets.coffee'
AbrReadingCollection = require '../../collections/core/abr-readings.coffee'

module.exports = Base.extend

  typeAttribute: 'abrGroupModel'
  urlRoot: '/api/abr/groups'

  props:
    type: 'string' #click, tone
    name: 'string'
    number: 'number'
    ear: 'string'
    date: 'date'
    source: 'string' #source of this abr record
    creator: 'any' #link to user
    created: 'date'

    analysis: 'object'
    fields: 'object'

    subjectId: 'any' #link to subject
    experiments: 'array' #objectId link to experiments

    tags: ['array', no, () -> []]

  session:
    selected: 'boolean'

  derived:
    editUrl:
      deps: ['id']
      fn: () -> "abr/groups/#{@.id}/edit"
    viewUrl:
      deps: ['id']
      fn: () -> "abr/groups/#{@.id}/view"
    maxFreq:
      deps: ['sets']
      fn: () ->_.max(@.sets.map (set) -> set.freq)
    minFreq:
      deps: ['sets']
      fn: () -> _.min(@.sets.map (set) -> set.freq)
    maxAmpl:
      deps: ['sets']
      fn: () -> _.max(@.sets.map (set) -> set.maxAmpl)
    minAmpl:
      deps: ['sets']
      fn: () -> _.min(@.sets.map (set) -> set.minAmpl)

  collections:
    sets: AbrSetsCollection

  quicksave: (callbacks) ->
    tempSets = @.sets
    @.sets = new AbrSetsCollection()
    @.save null,
      success: (model, xhr, options) ->
        model.sets = tempSets
        callbacks.success(model,xhr,options)
      error: (model, xhr, options) ->
        model.sets = tempSets
        callback.error(model,xhr,options)

  lazyLoadSets: (callback) ->
    @.sets = new AbrSetsCollection()
    @.sets.on 'query:loaded', () =>
      @.sets.each (set) => set.abrGroup = @
      callback()
    @.sets.query {groupId: @.id}

  lazyLoadAll: (callback) ->
    @.lazyLoadSets () =>
      async.each( @.sets,
        (set, cb) ->set.lazyLoadReadings(cb)
      , callback)

  getReadings: (callback) ->
    myCollection = new AbrReadingCollection()
    @.lazyLoadAll () =>
      @.sets.each (set) ->
        set.readings.each (reading) ->
          myCollection.add reading
      callback(null, myCollection)

