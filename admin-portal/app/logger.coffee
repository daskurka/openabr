bunyan = require 'browser-bunyan'

module.exports = class Logger

  constructor: () ->
    @.logs = []
    @maxLength = 800

    options =
      name: "admin-portal"
      streams: [
        {level: 'trace', stream: new bunyan.ConsoleFormattedStream(), type: 'raw'}
        {level: 'trace', stream: @, type: 'raw'}
      ]

    @.log = bunyan.createLogger(options)

  write: (doc) ->
    @.logs.push doc

    #if the length is max length then pop one out
    if @.logs.length is @.maxLength
      @.logs.pop()

    #if the length is greater... somehow then slice to correct length
    else if @.logs.length > @.maxLength
      @.logs = @.logs.slice(0,@.maxLength)
