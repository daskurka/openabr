Account = require './accountModel'
line = require '../utils/line'

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