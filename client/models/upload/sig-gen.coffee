State = require 'ampersand-state'
AbrGroupCollection = require '../../collections/core/abr-groups.coffee'

module.exports = State.extend

  props:
    source: 'string'
    creator: 'any' #objectId
    created: 'date'
    date: 'date'
    filename: 'string'

  collections:
    groups: AbrGroupCollection

