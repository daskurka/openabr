Account = require './accountModel'
line = require '../utils/line'


exports.create = (req, res) ->
  line.debug 'Account User Controller', 'Creating new account user'

  account = new Account req.body
  account.save (err) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.read = (req, res) ->
  line.debug 'Account User Controller', 'Reading account user: ', req.params.id

  query = Account.findById req.params.id
  query.exec (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.update = (req, res) ->
  line.debug 'Account User Controller', 'Updating account user: ', req.params.id

  Account.findByIdAndUpdate req.params.id, req.body, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account User Controller', 'Removing account user: ', req.params.id

  # remove user
  Account.findByIdAndRemove req.params.id, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send 200

exports.query = (req, res) ->
  line.debug 'Account User Controller', 'Querying account users: no params'

  #query all
  Account.find req.body, (err, accounts) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      req.send accounts