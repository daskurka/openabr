Base = require '../base.coffee'
_ = require 'lodash'

AbrSetsCollection = require '../../collections/core/abr-sets.coffee'

module.exports = Base.extend

  typeAttribute: 'abrGroupModel'
  urlRoot: '/api/abr/groups'

  props:
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

  session:
    selected: 'boolean'

  derived:
    maxFreq:
      deps: ['sets']
      fn: () ->_.max(@.sets.map (set) -> set.freq)
    minFreq:
      deps: ['sets']
      fn: () -> _.min(@.sets.map (set) -> set.freq)

  collections:
    sets: AbrSetsCollection