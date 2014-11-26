Account = require './accountModel'
line = require '../utils/line'
handle = require '../utils/handleError'


exports.create = (req, res) ->
  line.debug 'Account User Controller', 'Creating new account user'

  account = new Account req.body
  account.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating account', 'accountUserController.create'
    else
      res.send account

exports.read = (req, res) ->
  line.debug 'Account User Controller', 'Reading account user: ', req.params.id

  query = Account.findById req.params.id
  query.exec (err, account) ->
    if err?
      return handle.error req, res, err, 'Error reading account', 'accountUserController.read'
    else
      res.send account

exports.update = (req, res) ->
  line.debug 'Account User Controller', 'Updating account user: ', req.params.id

  Account.findByIdAndUpdate req.params.id, req.body, (err, account) ->
    if err?
      return handle.error req, res, err, 'Error updating account', 'accountUserController.update'
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account User Controller', 'Removing account user: ', req.params.id

  # remove user
  Account.findByIdAndRemove req.params.id, (err, account) ->
    if err?
      return handle.error req, res, err, 'Error removing account', 'accountUserController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'Account User Controller', 'Querying account users: no params'

  #query all
  Account.find req.params, (err, accounts) ->
    if err?
      return handle.error req, res, err, 'Error querying accounts', 'accountUserController.query'
    else
      res.send accounts