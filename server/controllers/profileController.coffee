User = require './userModel'
Account = require './accountModel'
Auth = require '../utils/authModel'
line = require '../utils/line'
handle = require '../utils/handleError'

#Functions for handling the loading and editing of the user profile
#but first we must make sure that the only user to do this is the signed in user
isCurrentUser = (req, res, next) ->
  #just compare the two userId
  requestUserId = req.params.id
  if req.auth.token.userId isnt requestUserId
    return handle.authError req, res, null, 'User cannot access a different users profile.', 'profileController.isCurrentUser'
  else
    do next

exports.read = (req, res) ->
  isCurrentUser req, res, () ->
    line.debug 'Profile Controller', 'Reading User: ', req.params.id

    #req.user already added in authenticate.user

    #want to add to the profile if the user is a system admin
    Auth.findOne {user: req.params.id}, (err, auth) ->
      if err?
        return handle.error req, res, err, 'Error reading profile', 'profileController.read'
      else
        result = req.user.toJSON()
        result.isSystemAdmin = auth.isAdmin
        res.send result

exports.update = (req, res) ->
  isCurrentUser req, res, () ->
    line.debug 'Profile Controller', 'Updating user: ', req.params.id

    User.findByIdAndUpdate req.params.id, req.body, (err, user) ->
      if err?
        return handle.error req, res, err, 'Error updating profile', 'profileController.update'
      else
        res.send user

exports.queryAccounts = (req, res) ->
  isCurrentUser req, res, () ->
    line.debug 'Profile Controller', 'Finding user accounts: ', req.params.id

    query = Account.find()
    query.or [
      {users: req.params.id}
      {admins: req.params.id}
    ]
    query.exec (err, accounts) ->
      if err?
        return handle.error req, res, err, 'Error querying accounts', 'profileController.queryAccounts'
      else
        res.send accounts