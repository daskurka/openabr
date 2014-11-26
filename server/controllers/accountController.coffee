Account = require './accountModel'
line = require '../utils/line'
handle = require '../utils/handleError'

exports.read = (req, res) ->
  line.debug 'Account Controller', 'Reading account: ', req.params.accountName

  #already found it
  res.send req.account

exports.update = (req, res) ->
  line.debug 'Account Controller', 'Updating account: ', req.params.accountName

  Account.findByIdAndUpdate req.account.id, req.body, (err, account) ->
    if err?
      return handle.error req, res, err, 'Error updating account', 'accountController.update'
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account Controller', 'Removing account: ', req.params.accountName

  # remove user
  req.account.remove (err, account) ->
    if err?
      return handle.error req, res, err, 'Error removing account', 'accountController.remove'
    else
      res.status(200)
      do res.send