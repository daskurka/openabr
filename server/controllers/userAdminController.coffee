User = require './userModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'User Admin Controller', 'Creating new user'

  user = new User req.body
  user.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating user', 'userAdminController.create'
    else
      res.send user

exports.read = (req, res) ->
  line.debug 'User Admin Controller', 'Reading User: ', req.params.id

  query = User.findById req.params.id
  query.exec (err, user) ->
    if err?
      return handle.error req, res, err, 'Error reading user', 'userAdminController.read'
    else
      res.send user

exports.update = (req, res) ->
  line.debug 'User Admin Controller', 'Updating user: ', req.params.id

  User.findByIdAndUpdate req.params.id, req.body, (err, user) ->
    if err?
      return handle.error req, res, err, 'Error updating user', 'userAdminController.update'
    else
      res.send user

exports.remove = (req, res) ->
  line.debug 'User Admin Controller', 'Removing User: ', req.params.id

  # remove user
  User.findByIdAndRemove req.params.id, (err, user) ->
    if err?
      return handle.error req, res, err, 'Error removing user', 'userAdminController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'User Admin Controller', 'Querying users: no params'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  User.find query, null, options, (err, users) ->
    if err?
      return handle.error req, res, err, 'Error querying users', 'userAdminController.query'
    else
      if not isPaged
        return res.send users

      #also find total possible records
      User.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting users', 'userAdminController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send users