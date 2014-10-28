restify = require 'restify'

server = restify.createServer()

server.get '/', (req, res, next) ->
  res.send('Hello there...')
  do next


server.listen 8080, () ->
  console.log 'Server started.....'