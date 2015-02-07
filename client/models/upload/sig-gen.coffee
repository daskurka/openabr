State = require 'ampersand-state'
AbrGroupCollection = require '../../collections/core/abr-groups.coffee'
SubjectModel = require '../../models/core/subject.coffee'

module.exports = State.extend

  props:
    source: 'string'
    creator: 'any' #objectId
    created: 'date'
    date: 'date'
    filename: 'string'
    ear: 'string'
    subject: 'object'

  collections:
    groups: AbrGroupCollection

