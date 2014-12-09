chalk = require 'chalk'

#debug, who, what and id
exports.debug = (prefix, text, id) ->

  isoDate = new Date().toISOString()
  datePart = chalk.magenta("[#{isoDate}]")

  idPart = if id? then chalk.cyan(id) else ''
  console.log "#{datePart} #{chalk.blue(prefix)} - #{chalk.green(text)}#{idPart}"