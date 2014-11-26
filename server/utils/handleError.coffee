chalk = require 'chalk'

exports.error = (req, res, error, hint, location) ->

  #set status code
  res.status(500)
  errorBody =
    statusCode: 500
    statusText: "Internal Server Error"

  #if in development show full error to console and return full error message with debug
  if req.isDevMode
    errorBody.debug = {}
    errorBody.debug.error = error
    errorBody.debug.hint = hint
    errorBody.debug.location = location

    console.log "#{chalk.red('ERROR:')} #{chalk.blue('500')} 'Internal Server Error' in #{chalk.yellow(location)} likely to be #{chalk.green(hint)}."
    if error? and error.length > 0
      console.log "#{chalk.red('ERROR:')} Raw Message: #{chalk.blue(error)}"

  res.send(errorBody)


exports.authError = (req, res, error, hint, location) ->

  #set status code
  res.status(401)
  errorBody =
    statusCode: 401
    statusText: "Not Authorised"

  #if in development show full error to console and return full error message with debug
  if req.isDevMode
    errorBody.debug = {}
    errorBody.debug.error = error
    errorBody.debug.hint = hint
    errorBody.debug.location = location

    console.log "#{chalk.red('ERROR:')} #{chalk.blue('401')} 'Not Authorised' in #{chalk.yellow(location)} likely to be #{chalk.green(hint)}."
    if error? and error.length > 0
      console.log "#{chalk.red('ERROR:')} Raw Message: #{chalk.blue(error)}"

  res.send(errorBody)