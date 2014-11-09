authenticate = require './utils/authenticate'

account = require './controllers/accountController'
accountUser = require './controllers/accountUserController'
user = require './controllers/userController'


module.exports = (server) ->

  #deserialise token if one exists
  server.use authenticate.deserialise

  #authentication routes first
  server.get '/auth/login', authenticate.login

  #routes for managing accounts - only system admin can do this
  server.post '/admin/accounts', authenticate.systemAdmin, account.create
  server.get '/admin/accounts/:id', authenticate.systemAdmin, account.read
  server.put '/admin/accounts/:id', authenticate.systemAdmin, account.update
  server.del '/admin/accounts/:id', authenticate.systemAdmin, account.remove
  server.get '/admin/accounts', authenticate.systemAdmin, account.query

  #routes for managing user - only system admin
  server.post '/admin/users', authenticate.systemAdmin, user.create
  server.get '/admin/users/:id', authenticate.systemAdmin, user.read
  server.put '/admin/users/:id', authenticate.systemAdmin, user.update
  server.del '/admin/users/:id', authenticate.systemAdmin, user.remove
  server.get '/admin/users', authenticate.systemAdmin, user.query

  #routes for managing account users
  server.post '/:accountName/users', authenticate.admin, accountUser.create
  server.get '/:accountName/users/:id', authenticate.admin, accountUser.read
  server.put '/:accountName/users/:id', authenticate.admin, accountUser.update
  server.del '/:accountName/users/:id', authenticate.admin, accountUser.remove
  server.get '/:accountName/users', authenticate.account, accountUser.query