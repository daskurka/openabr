User = require './userModel'
Auth = require '../utils/authModel'
line = require '../utils/line'
handle = require '../utils/handleError'
authenticate = require '../utils/authenticate'

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
        result.isAdmin = auth.isAdmin
        res.send result

exports.update = (req, res) ->
  isCurrentUser req, res, () ->
    line.debug 'Profile Controller', 'Updating user: ', req.params.id

    User.findByIdAndUpdate req.params.id, req.body, (err, user) ->
      if err?
        return handle.error req, res, err, 'Error updating profile', 'profileController.update'
      else
        res.send user

exports.changePassword = (req, res) ->
  isCurrentUser req, res, () ->
    line.debug 'Profile Controller', 'Changing user password: ', req.params.id

    if not req.body.new?
      noNewError = 'No new password provided to change too.'
      return handle.error req, res, noNewError, noNewError, 'profileController.changePassword'
    if not req.body.old?
      noOldError = 'No old password provided to change from.'
      return handle.error req, res, noOldError, noOldError, 'profileController.changePassword'

    authenticate.checkPassword req.params.id, req.body.old, (err, matches) ->
      if err?
        return handle.error req, res, err, 'Error checking users old password.', 'profileController.changePassword'

      if not matches
        return handle.authError req, res, 'N/A', 'Provided old password doesnt match.', 'profileController.changePassword'

      #todo - check new password is correctly length etc

      authenticate.resetAuthentication req.params.id, req.body.new, (err) ->
        if err?
          return handle.error req, res, err, 'Error resetting auth for user', 'profileController.changePassword'

        res.statusCode(200)
        res.send {message: 'Password changed.'}


