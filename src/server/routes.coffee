authenticate = require './utils/authenticate'
accountAdmin = require './controllers/accountAdminController'
userAdmin = require './controllers/userAdminController'
account = require './controllers/accountController'
accountUser = require './controllers/accountUserController'
profile = require './controllers/profileController'


module.exports = (server) ->

  #deserialise token if one exists
  server.use authenticate.deserialise

  #authentication routes first
  server.get '/auth/login', authenticate.login

  #routes for managing accounts - only system admin can do this
  server.post '/admin/accounts', authenticate.systemAdmin, accountAdmin.create
  server.get '/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.read
  server.put '/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.update
  server.del '/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.remove
  server.get '/admin/accounts', authenticate.systemAdmin, accountAdmin.query

  #routes for managing user - only system admin
  server.post '/admin/users', authenticate.systemAdmin, userAdmin.create
  server.get '/admin/users/:id', authenticate.systemAdmin, userAdmin.read
  server.put '/admin/users/:id', authenticate.systemAdmin, userAdmin.update
  server.del '/admin/users/:id', authenticate.systemAdmin, userAdmin.remove
  server.get '/admin/users', authenticate.systemAdmin, userAdmin.query

  #routes for user profile - only current user
  server.get '/profile/:id', authenticate.user, profile.read
  server.put '/profile/:id', authenticate.user, profile.update
  server.get '/profile/:id/accounts', authenticate.user, profile.queryAccounts

  #routes for manging accounts - only admin can edit/update - members can read
  server.get '/:accountName', authenticate.account, account.read
  server.put '/:accountName', authenticate.admin, account.update
  server.del '/:accountName', authenticate.admin, account.remove

  #routes for managing account users
  server.post '/:accountName/users', authenticate.admin, accountUser.create
  server.get '/:accountName/users/:id', authenticate.account, accountUser.read
  server.put '/:accountName/users/:id', authenticate.admin, accountUser.update
  server.del '/:accountName/users/:id', authenticate.admin, accountUser.remove
  server.get '/:accountName/users', authenticate.account, accountUser.query