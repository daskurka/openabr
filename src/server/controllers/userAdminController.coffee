User = require './userModel'
line = require '../utils/line'


exports.create = (req, res) ->
  line.debug 'User Admin Controller', 'Creating new user'

  user = new User req.body
  user.save (err) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send user

exports.read = (req, res) ->
  line.debug 'User Admin Controller', 'Reading User: ', req.params.id

  query = User.findById req.params.id
  query.exec (err, user) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send user

exports.update = (req, res) ->
  line.debug 'User Admin Controller', 'Updating user: ', req.params.id

  User.findByIdAndUpdate req.params.id, req.body, (err, user) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send user

exports.remove = (req, res) ->
  line.debug 'User Admin Controller', 'Removing User: ', req.params.id

  # remove user
  User.findByIdAndRemove req.params.id, (err, user) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      res.send 200

exports.query = (req, res) ->
  line.debug 'User Admin Controller', 'Querying users: no params'

  #query all
  User.find req.body, (err, users) ->
    if err?
      return res.send 500, "Internal Server Error: #{err}"
    else
      req.send users