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
  server.get '/api/auth/login', authenticate.login

  #routes for managing accounts - only system admin can do this
  server.get '/api/admin/accounts/lookup/:urlName', authenticate.systemAdmin, accountAdmin.lookup
  server.post '/api/admin/accounts', authenticate.systemAdmin, accountAdmin.create
  server.get '/api/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.read
  server.put '/api/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.update
  server.delete '/api/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.remove
  server.get '/api/admin/accounts', authenticate.systemAdmin, accountAdmin.query

  #routes for managing user - only system admin
  server.post '/api/admin/users', authenticate.systemAdmin, userAdmin.create
  server.get '/api/admin/users/:id', authenticate.systemAdmin, userAdmin.read
  server.put '/api/admin/users/:id', authenticate.systemAdmin, userAdmin.update
  server.delete '/api/admin/users/:id', authenticate.systemAdmin, userAdmin.remove
  server.get '/api/admin/users', authenticate.systemAdmin, userAdmin.query

  #routes for user profile - only current user
  server.get '/api/profile/:id', authenticate.user, profile.read
  server.put '/api/profile/:id', authenticate.user, profile.update
  server.get '/api/profile/:id/accounts', authenticate.user, profile.queryAccounts

  #routes for manging accounts - only admin can edit/update - members can read
  server.get '/api/:accountName', authenticate.account, account.read
  server.put '/api/:accountName', authenticate.admin, account.update
  server.delete '/api/:accountName', authenticate.admin, account.remove

  #routes for managing account users
  server.post '/api/:accountName/users', authenticate.admin, accountUser.create
  server.get '/api/:accountName/users/:id', authenticate.account, accountUser.read
  server.put '/api/:accountName/users/:id', authenticate.admin, accountUser.update
  server.delete '/api/:accountName/users/:id', authenticate.admin, accountUser.remove
  server.get '/api/:accountName/users', authenticate.account, accountUser.query