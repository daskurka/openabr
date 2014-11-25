Account = require './accountModel'
line = require '../utils/line'

exports.read = (req, res) ->
  line.debug 'Account Controller', 'Reading account: ', req.params.accountName

  #already found it
  res.send req.account

exports.update = (req, res) ->
  line.debug 'Account Controller', 'Updating account: ', req.params.accountName

  Account.findByIdAndUpdate req.account.id, req.body, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account Controller', 'Removing account: ', req.params.accountName

  # remove user
  req.account.remove (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send 200