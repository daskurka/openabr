mongoose = require 'mongoose'
jwt = require 'jwt-simple'
_ = require 'underscore'
pbkdf2 = require 'pbkdf2-sha256'
crypto = require 'crypto'

line = require './line'
handle = require './handleError'
User = require '../models/userModel'
Auth = require './../models/authModel'

#settings TODO: put somewhere else... SEROIUSLY secret should not be here
secret = 'FbBgywYjx6HPPzjKHqJsDhX8'
hashIterations = 50000
hashLength = 128

#for simplicity i am merging all query parameters with params from each route
#why you ask? this started out with restify not express, this is default for restify
mergeParams = (req) ->
  Object.keys(req.query).forEach (key) ->
    if req.params[key]? then return no

    req.params[key] = req.query[key]
    return yes

#Deseralise the token and attach it to the request
exports.deserialise = (req, res, next) ->

  req.auth = {}
  if req.headers.token?
    req.auth.token = jwt.decode req.headers.token, secret

    if req.auth.token? and req.auth.token.userId?
      req.auth.authenticated = yes
    else
      req.auth.authenticated = no
      req.auth.error = 'Malformed token'
  else
    req.auth.authenticated = no
    req.auth.error = 'No token'

  do next


#Seralise the token for the given user
exports.serialise = (user) ->
  token =
    userId: user._id
    loginTime: new Date()
  return jwt.encode token, secret


#This function reads the authentication token if there is one then attaches the user
#if they exist in the database, this is for editing profile etc
exports.user = (req, res, next) ->

  #merge query into params
  mergeParams(req)

  #if user not authenticated then return not authorised
  if not req.auth.authenticated
    return handle.authError req, res, req.auth.error, 'Token did not authenticated this user correctly.', 'authenticate.user'

  #get user object
  userId = req.auth.token.userId
  User.findOne {_id: userId}, (err, user) ->
    if err? or not user?
      return handle.authError req, res, err, 'Could not find user account for userId provided.', 'authenticate.user'

    #attach
    req.user = user
    do next

#This function will check if the current user is a real system admin
exports.admin = (req, res, next) ->

  #load user object in req
  exports.user req, res, () ->

    #find matching authentication, we do not need account for this
    Auth.findOne {user: req.user._id}, (err, auth) ->
      if err? or not auth?
        return handle.authError req, res, err, 'Could not find "auth" to match user.', 'authenticate.systemAdmin'

      #check if user is system admin
      if auth.isAdmin
        do next
      else
        return handle.authError req, res, null, 'User is not identified in "auth" as a system admin.', 'authenticate.systemAdmin'

#This function is used to authenticate a user by checking their password
#against the database, a response will indicate sucessful login
#anything else will return a 401
exports.login = (req, res) ->

  #merge query into params
  mergeParams(req)

  email = req.params.email
  password = req.params.password

  #find the user from the email
  User.findOne {email: email}, (err, user) ->
    if err? or not user?
      return handle.authError req, res, err, 'Cannot find user with email provided.', 'authenticate.login'


    #find the auth from the user
    Auth.findOne {user: user.id}, (err, auth) ->
      if err?
        return handle.authError req, res, err, 'Cannot find matching "auth" model for user.', 'authenticate.login'

      resultantHash = pbkdf2(password, auth.passwordSalt, hashLength, hashIterations)
      resultantHash = resultantHash.toString('base64')

      if resultantHash is auth.passwordHash
        res.send
          token: exports.serialise(user)
          isAdmin: auth.isAdmin
          user: user
      else
        return handle.authError req, res, null, 'Password hash did not match hash in database.', 'authenticate.login'

exports.checkPassword = (userId, password, callback) ->
  #find the auth from the user
  Auth.findOne {user: userId}, (err, auth) ->
    if err? then return callback(err)

    resultantHash = pbkdf2(password, auth.passwordSalt, hashLength, hashIterations)
    resultantHash = resultantHash.toString('base64')

    if resultantHash is auth.passwordHash
      callback(null, yes)
    else
      callback(null, no)

#this function creates a new authentication entry for a particular user
exports.createAuthentication = (userId, password, callback) ->

  line.debug 'Authentication', 'Creating new password hash for: ', userId

  salt = crypto.randomBytes(hashLength).toString('base64')
  hash = pbkdf2(password, salt, hashLength, hashIterations)
  hash = hash.toString('base64')

  auth = new Auth
    passwordHash: hash
    passwordSalt : salt
    user: userId
    isAdmin: no
  auth.save (err) ->
    if err?
      callback(err)
    else
      callback(null, auth)

#this function is for finding and resetting an authentication
exports.resetAuthentication = (userId, password, callback) ->

  line.debug 'Authentication', 'Removing old password for: ', userId

  Auth.findOne {user: userId }, (err, oldAuth) ->
    if err?
      callback(err)

    isAdmin = oldAuth.isAdmin

    Auth.where({user: userId}).findOneAndRemove (err) ->
      if err?
        callback(err)
      else
        exports.createAuthentication userId, password, (err, newAuth) ->
          if err? then callback(err)

          newAuth.isAdmin = isAdmin
          newAuth.save (err) ->
            if err? then callback(err) else callback(null, newAuth)