State = require 'ampersand-state'

Model = require '../models/core/experiment.coffee'

module.exports = State.extend

  session:
    lookup: 'object'

  initialize: () ->
    @.lookup = {}

  lookupName: (id, callback) ->
    found = no
    for key of @.lookup
      if key is id
        found = yes

    if found
      return callback(null, @.lookup[id])

    if not @.lookup?
      @.lookup = {}

    model = new Model(id: id)
    model.fetch
      success: () =>
        @.lookup[id] = model.name
        callback(null, model.name)
      error: () ->
        callback('Error looking up name...')

















