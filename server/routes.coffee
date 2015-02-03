authenticate = require './utils/authenticate'
userAdmin = require './controllers/userAdminController'
subject = require './controllers/subjectController'
experiment = require './controllers/experimentController'
dataField = require './controllers/dataFieldController'
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
  server.get '/api/profile/users', authenticate.user, profile.users
  server.get '/api/profile/:id', authenticate.user, profile.read
  server.put '/api/profile/:id', authenticate.user, profile.update
  server.post '/api/profile/:id/change-password', authenticate.user, profile.changePassword

  #subject routes
  server.post '/api/subjects', authenticate.user, subject.create
  server.get '/api/subjects/count', authenticate.user, subject.count
  server.get '/api/subjects/:id', authenticate.user, subject.read
  server.put '/api/subjects/:id', authenticate.user, subject.update
  server.delete '/api/subjects/:id', authenticate.user, subject.remove
  server.get '/api/subjects', authenticate.user, subject.query

  #experiment routes
  server.post '/api/experiments', authenticate.user, experiment.create
  server.get '/api/experiments/:id', authenticate.user, experiment.read
  server.put '/api/experiments/:id', authenticate.user, experiment.update
  server.delete '/api/experiments/:id', authenticate.user, experiment.remove
  server.get '/api/experiments', authenticate.user, experiment.query

  #data field routes
  server.post '/api/data-fields', authenticate.admin, dataField.create
  server.get '/api/data-fields/check', authenticate.admin, dataField.checkDbName
  server.get '/api/data-fields/:id', authenticate.user, dataField.read
  server.put '/api/data-fields/:id', authenticate.admin, dataField.update
  server.delete '/api/data-fields/:id', authenticate.admin, dataField.remove
  server.get '/api/data-fields', authenticate.user, dataField.query