User = require './userModel'
line = require '../utils/line'
handle = require '../utils/handleError'

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

  #this handles basic regex contained on bottom
  for part of req.params
    for innerPart of req.params[part]
      if innerPart is '$regex'
        if req.params[part]['$options']?
          req.params[part] = new RegExp(req.params[part]['$regex'], req.params[part]['$options'])
        else
          req.params[part] = new RegExp(req.params[part]['$regex'])

  #query all
  User.find req.params, (err, users) ->
    if err?
      return handle.error req, res, err, 'Error querying users', 'userAdminController.query'
    else
      res.send users