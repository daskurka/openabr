mongoose = require 'mongoose'
jwt = require 'jwt-simple'
_ = require 'underscore'
pbkdf2 = require 'pbkdf2-sha256'
crypto = require 'crypto'

User = require '../controllers/userModel'
Account = require '../controllers/accountModel'
Auth = require './authModel'

#settings TODO: put somewhere else... SEROIUSLY secret should not be here
secret = 'FbBgywYjx6HPPzjKHqJsDhX8'
hashIterations = 50000
hashLength = 128


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

  #if user not authenticated then return not authorised
  if not req.auth.authenticated
    return res.send 401, 'Not authorised'

  #get user object
  userId = req.auth.token.userId
  User.findOne {_id: userId}, (err, user) ->
    if err? or not user?
      return res.send 401, 'Not authorised'

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
        return res.send 401, 'Not Authorised'

      #attach
      req.account = account

      #check if the user is in users and admins
      req.isUser = _.contains req.account.users, req.user._id
      req.isAdmin = _.contains req.account.admins, req.user._id

      #for this we want them to continue if they are in either
      if req.isUser or req.isAdmin
        do next
      else
        res.send 401, 'Not Authorised'


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
      res.send 401, 'Not Authorised'


#This function will check if the current user is a real system admin
#This is for doing things like editing the entire system or access account records
#NOTE: system admin does not need account to be in the path
exports.systemAdmin = (req, res, next) ->

  #load user object in req
  exports.user req, res, () ->

    #find matching authentication, we do not need account for this
    Auth.findOne {user: req.user._id}, (err, auth) ->
      if err? or not auth?
        return res.send 401, 'Not Authorised'

      #check if user is system admin
      if auth.isAdmin
        do next
      else
        res.send 401, 'Not Authorised'

#This function is used to authenticate a user by checking their password
#against the database, a response will indicate sucessful login
#anything else will return a 401
exports.login = (req, res) ->

  email = req.params.email
  password = req.params.password

  #find the user from the email
  User.findOne {email: email}, (err, user) ->
    if err? or not user?
      console.log err
      return res.send 401, 'Not Authorised'

    #find the auth from the user
    Auth.findOne {user: user.id}, (err, auth) ->
      if err?
        console.log err
        return res.send 401, 'Not Authorised'

      resultantHash = pbkdf2(password, auth.passwordSalt, hashLength, hashIterations)
      resultantHash = resultantHash.toString('base64')

      if resultantHash is auth.passwordHash
        res.send
          token: exports.serialise(user)
          isSystemAdmin: auth.isAdmin
          user: user
      else
        return res.send 401, 'Not Authorised'

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
