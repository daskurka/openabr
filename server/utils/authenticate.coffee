mongoose = require 'mongoose'
jwt = require 'jwt-simple'
_ = require 'underscore'
pbkdf2 = require 'pbkdf2-sha256'
crypto = require 'crypto'

handle = require './handleError'
User = require '../controllers/userModel'
Account = require '../controllers/accountModel'
Auth = require './authModel'

#settings TODO: put somewhere else... SEROIUSLY secret should not be here
secret = 'FbBgywYjx6HPPzjKHqJsDhX8'
hashIterations = 50000
hashLength = 128

#for simplicity i am merging all query parameters with params from each route
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


#This function uses the above user function and adds account info for an account path
#user and account object for the given request and passes if they are allowed.
exports.account = (req, res, next) ->

  #load user object in req
  exports.user req, res, () ->

    #find the account based off the parameter
    urlName = req.params.accountName
    Account.findOne {urlName}, (err, account) ->
      if err? or not account?
        return handle.authError req, res, err, 'Could not find matching account with the specified account url.', 'authenticate.account'

      #attach
      req.account = account

      #check if the user is in users and admins
      req.isUser = do () ->
        for user in req.account.users
          if user.equals(req.user._id) then return true
        return false
      req.isAdmin = do () ->
        for admin in req.account.admins
          if admin.equals(req.user._id) then return true
        return false

      #for this we want them to continue if they are in either
      if req.isUser or req.isAdmin
        do next
      else
        return handle.authError req, res, null, 'User is not identified in "account" as a account user.', 'authenticate.account'


#This function is an extension of the above account function except that it
#only allows through requests for users that are part of the admins for the
#current account.
exports.admin = (req, res, next) ->

  #first load user object and account
  exports.account req, res, () ->

    #for admin we only want them to continue if they are in the admin part of account
    if req.isAdmin
      do next
    else
      return handle.authError req, res, null, 'User is not identified in "account" as a account admin.', 'authenticate.admin'


#This function will check if the current user is a real system admin
#This is for doing things like editing the entire system or access account records
#NOTE: system admin does not need account to be in the path
exports.systemAdmin = (req, res, next) ->

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
          isSystemAdmin: auth.isAdmin
          user: user
      else
        return handle.authError req, res, null, 'Password hash did not match hash in database.', 'authenticate.login'

#this function creates a new authentication entry for a particular user
exports.createAuthentication = (userId, password, callback) ->

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
