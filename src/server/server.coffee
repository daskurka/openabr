restify = require 'restify'
chalk = require 'chalk'
routes = require './routes'
mongoose = require './mongoose'
first = require './utils/firstRun'

#configure server
server = restify.createServer
  name: 'openabr-server'
  version: '0.1.0'
server.port = process.env.PORT || 8080

console.log "#{chalk.red(server.name)} is starting..."

#middlewares
server.use restify.acceptParser(server.acceptable)
server.use restify.queryParser()
server.use restify.bodyParser()

#connect and configure database and ODM
mongoose(server)

#do first run configuration
first(server)

#register routes
routes(server)

#and start
server.listen server.port, () ->
  console.log "#{chalk.red(server.name)} #{chalk.dim("[#{server.versions}]")} is listening at #{chalk.blue(server.url)}"