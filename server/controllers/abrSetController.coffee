AbrSet = require '../models/abrSetModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'AbrSet Controller', 'Creating new abr set'

  abrSet = new AbrSet req.body
  abrSet.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating abr set', 'abrSetController.create'
    res.send abrSet

exports.read = (req, res) ->
  line.debug 'AbrSet Controller', 'Reading abr set: ', req.params.id

  query = AbrSet.findById req.params.id
  query.exec (err, abrSet) ->
    if err?
      return handle.error req, res, err, 'Error reading abr set', 'abrSetController.read'
    else
      res.send abrSet

exports.update = (req, res) ->
  line.debug 'AbrSet Controller', 'Updating abr set: ', req.params.id

  AbrSet.findByIdAndUpdate req.params.id, req.body, (err, abrSet) ->
    if err?
      return handle.error req, res, err, 'Error updating abr set', 'abrSetController.update'
    else
      res.send abrSet

exports.remove = (req, res) ->
  line.debug 'AbrSet Controller', 'Removing abr set: ', req.params.id

  AbrSet.findByIdAndRemove req.params.id, (err, abrSet) ->
    if err?
      return handle.error req, res, err, 'Error removing abr set', 'abrSetController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'AbrSet Controller', 'Querying abr sets: no params'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  AbrSet.find query, null, options, (err, abrSets) ->
    if err?
      return handle.error req, res, err, 'Error querying abr sets', 'abrSetController.query'
    else
      if not isPaged
        return res.send abrSets

      #also find total possible records
      AbrSet.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting abr sets', 'abrSetController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send abrSets

exports.count = (req, res) ->
  line.debug 'AbrSet Controller', 'Counting abr sets: no params'

  #direct count query, anything is acceptable
  query = req.params

  AbrSet.count query, (err, found) ->
    if err?
      return handle.error req, res, err, 'Error counting abr sets', 'abrSetController.count'
    else
      res.send {found}