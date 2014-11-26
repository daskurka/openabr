Account = require './accountModel'
line = require '../utils/line'
pager = require '../utils/pager'
handle = require '../utils/handleError'

exports.create = (req, res) ->
  line.debug 'Account Admin Controller', 'Creating new account'

  account = new Account req.body
  account.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating account', 'accountAdminController.create'
    else
      res.send account

exports.read = (req, res) ->
  line.debug 'Account Admin Controller', 'Reading account: ', req.params.id

  query = Account.findById req.params.id
  query.exec (err, account) ->
    if err?
      return handle.error req, res, err, 'Error reading account', 'accountAdminController.read'
    else
      res.send account

exports.lookup = (req, res) ->
  line.debug 'Account Admin Controller', 'Looking up account name: ', req.params.urlName

  Account.findOne {urlName: req.params.urlName}, (err, account) ->
    if err?
      return handle.error req, res, err, 'Error looking up account', 'accountAdminController.lookup'
    else
      res.send account

exports.update = (req, res) ->
  line.debug 'Account Admin Controller', 'Updating account: ', req.params.id

  Account.findByIdAndUpdate req.params.id, req.body, (err, account) ->
    if err?
      return handle.error req, res, err, 'Error updating account', 'accountAdminController.update'
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account Admin Controller', 'Removing account: ', req.params.id

  # remove user
  Account.findByIdAndRemove req.params.id, (err, account) ->
    if err?
      return handle.error req, res, err, 'Error removing account', 'accountAdminController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'Account Admin Controller', 'Querying accounts'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  Account.find query, null, options, (err, accounts) ->
    if err?
      return handle.error req, res, err, 'Error querying accounts', 'accountAdminController.query'
    else
      if not isPaged
        return res.send accounts

      #also find total possible records
      Account.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting accounts', 'accountAdminController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send accounts