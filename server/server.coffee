express = require 'express'
chalk = require 'chalk'
path = require 'path'
helmet = require 'helmet'
bodyParser = require 'body-parser'
Moonboots = require 'moonboots-express'
compress = require 'compression'
serveStatic = require 'serve-static'
stylizer = require 'stylizer'
templatizer = require 'templatizer'

routes = require './routes'
mongoose = require './mongoose'
first = require './utils/firstRun'

#configure server
server = express()
server.set 'name', 'openabr-server'
server.set 'version', '0.1.0'
server.set 'port', process.env.PORT || 8080
server.set 'mongo', process.env.MONGO_URL || 'mongodb://localhost/dev'
console.log process.env.MONGO_URL
server.set 'mode', process.env.NODE_ENV || 'development'
isDevMode = server.get('mode') is 'development'

console.log "#{chalk.red(server.get('name'))} is starting..."

#helper for path fixing
fixPath = (pathString) -> path.resolve(path.normalize(pathString))

#middlewares
server.use compress()
server.use serveStatic(fixPath('public'))
server.use bodyParser.urlencoded({extended: no})
server.use bodyParser.json()
server.use helmet.xssFilter()
server.use helmet.nosniff()

#connect and configure database and ODM
mongoose(server)

#do first run configuration
first(server)

#register routes
routes(server)

boots = new Moonboots
  moonboots:
    main: fixPath('client/app.coffee')
    jsFileName: 'openabr'
    cssFileName: 'openabr'
    developmentMode: isDevMode
    libraries: []
    stylesheets: [
      fixPath('public/css/vendor/bootstrap.min.css')
      fixPath('public/css/vendor/bootstrap-theme.min.css')
      fixPath('public/css/vendor/select2.css')
      fixPath('public/css/app.css')
    ]
    browserify:
      debug: no
      extensions: ['.coffee']
      transforms: [
        require('coffeeify')
      ]
    beforeBuildJS: () ->
      if isDevMode
        templatizer(fixPath('templates'), fixPath('client/templates.js'))
    beforeBuildCSS: (done) ->
      if isDevMode
        stylizer
          infile: fixPath('public/css/app.styl')
          outfile: fixPath('public/css/app.css')
          development: yes
          , done
      else
        done()
  server: server

#and start
server.listen server.get('port'), () ->
  console.log "#{chalk.red(server.get('name'))} #{chalk.dim("[#{server.get('version')}]")} is listening at #{chalk.blue(server.get('port'))}"