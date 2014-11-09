chalk = require 'chalk'

#debug, who, what and id
exports.debug = (prefix, text, id) ->
  idPart = if id? then chalk.cyan(id) else ''
  console.log "#{chalk.blue(prefix)} - #{chalk.green(text)}#{idPart}"