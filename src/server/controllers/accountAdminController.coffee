Account = require './accountModel'
line = require '../utils/line'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'Account Admin Controller', 'Creating new account'

  account = new Account req.body
  account.save (err) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.read = (req, res) ->
  line.debug 'Account Admin Controller', 'Reading account: ', req.params.id

  query = Account.findById req.params.id
  query.exec (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.update = (req, res) ->
  line.debug 'Account Admin Controller', 'Updating account: ', req.params.id

  Account.findByIdAndUpdate req.params.id, req.body, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send account

exports.remove = (req, res) ->
  line.debug 'Account Admin Controller', 'Removing account: ', req.params.id

  # remove user
  Account.findByIdAndRemove req.params.id, (err, account) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send 200

exports.query = (req, res) ->
  line.debug 'Account Admin Controller', 'Querying accounts'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  Account.find query, null, options, (err, accounts) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      if not isPaged
        return res.send accounts

      #also find total possible records
      Account.count query, (err, totalFound) ->
        if err?
          return res.send 500, "Internal Server Error: #{err}"
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send accounts