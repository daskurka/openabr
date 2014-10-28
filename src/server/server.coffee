restify = require 'restify'

port = process.env.PORT || 8080

server = restify.createServer()

server.get '/test/:name', (req, res, next) ->
  res.send('Hello there... ' + req.params.name)
  do next



server.listen port, () ->
  console.log '%s listening at %s', server.name, server.url