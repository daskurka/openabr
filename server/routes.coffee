authenticate = require './utils/authenticate'
userAdmin = require './controllers/userAdminController'
profile = require './controllers/profileController'


module.exports = (server) ->

  #deserialise token if one exists
  server.use authenticate.deserialise

  #authentication routes first
  server.get '/api/auth/login', authenticate.login

  #routes for managing user - only system admin
  server.post '/api/admin/users', authenticate.admin, userAdmin.create
  server.get '/api/admin/users/check', authenticate.admin, userAdmin.checkEmail
  server.get '/api/admin/users/reset', authenticate.admin, userAdmin.resetPassword
  server.get '/api/admin/users/:id', authenticate.admin, userAdmin.read
  server.put '/api/admin/users/:id', authenticate.admin, userAdmin.update
  server.delete '/api/admin/users/:id', authenticate.admin, userAdmin.remove
  server.get '/api/admin/users', authenticate.admin, userAdmin.query

  #routes for user profile - only current user
  server.get '/api/profile/:id', authenticate.user, profile.read
  server.put '/api/profile/:id', authenticate.user, profile.update