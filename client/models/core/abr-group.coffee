State = require 'ampersand-state'
_ = require 'lodash'
AbrSetsCollection = require '../../collections/core/abr-sets.coffee'

module.exports = State.extend

  typeAttribute: 'abrGroupModel'

  props:
    fields: 'object'
    name: 'string'
    number: 'number'
    ear: 'string'

  derived:
    maxFreq:
      deps: ['sets']
      fn: () ->_.max(@.sets.map (set) -> set.frequency)
    minFreq:
      deps: ['sets']
      fn: () -> _.min(@.sets.map (set) -> set.frequency)

  collections:
    sets: AbrSetsCollection