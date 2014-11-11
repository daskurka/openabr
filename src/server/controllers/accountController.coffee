Account = require './accountModel'
line = require '../utils/line'

exports.create = (req, res) ->
  line.debug 'Account Controller', 'Creating new account'

  account = new Account req.body
  account.save (err) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.read = (req, res) ->
  line.debug 'Account Controller', 'Reading account: ', req.params.id

  query = Account.findById req.params.id
  query.exec (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.update = (req, res) ->
  line.debug 'Account Controller', 'Updating account: ', req.params.id

  Account.findByIdAndUpdate req.params.id, req.body, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account Controller', 'Removing account: ', req.params.id

  # remove user
  Account.findByIdAndRemove req.params.id, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send 200

exports.query = (req, res) ->
  line.debug 'Account Controller', 'Querying accounts: no params'

  #query all
  Account.find req.body, (err, accounts) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      req.send accounts