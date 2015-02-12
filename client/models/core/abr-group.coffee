Base = require '../base.coffee'
_ = require 'lodash'

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
    @.sets.on 'query:loaded', callback
    @.sets.query {groupId: @.id}

  getReadings: (callback) ->
    @.lazyLoadSets () =>
      setIds = @.sets.map((set) -> return set.id)
      collection = new AbrReadingCollection()
      collection.on 'query:loaded', () =>
        #now assign set models to the readings
        collection.each (reading) =>
          @.sets.each (set) ->
            if reading.setId is set.id
              reading.abrSet = set
        callback(null, collection)
      collection.query {setId: {$in: setIds}}
