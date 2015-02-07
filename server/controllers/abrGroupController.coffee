AbrGroup = require '../models/abrGroupModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'AbrGroup Controller', 'Creating new subject'

  abrGroup = new AbrGroup req.body
  abrGroup.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating abr group', 'abrGroupController.create'
    res.send abrGroup

exports.read = (req, res) ->
  line.debug 'AbrGroup Controller', 'Reading abr group: ', req.params.id

  query = AbrGroup.findById req.params.id
  query.exec (err, abrGroup) ->
    if err?
      return handle.error req, res, err, 'Error reading abr group', 'abrGroupController.read'
    else
      res.send abrGroup

exports.update = (req, res) ->
  line.debug 'AbrGroup Controller', 'Updating abr group: ', req.params.id

  AbrGroup.findByIdAndUpdate req.params.id, req.body, (err, abrGroup) ->
    if err?
      return handle.error req, res, err, 'Error updating abr group', 'abrGroupController.update'
    else
      res.send abrGroup

exports.remove = (req, res) ->
  line.debug 'AbrGroup Controller', 'Removing abr group: ', req.params.id

  AbrGroup.findByIdAndRemove req.params.id, (err, abrGroup) ->
    if err?
      return handle.error req, res, err, 'Error removing abr group', 'abrGroupController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'AbrGroup Controller', 'Querying abr groups: no params'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  AbrGroup.find query, null, options, (err, abrGroups) ->
    if err?
      return handle.error req, res, err, 'Error querying abr groups', 'abrGroupController.query'
    else
      if not isPaged
        return res.send abrGroups

      #also find total possible records
      AbrGroup.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting abr groups', 'abrGroupController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send abrGroups

exports.count = (req, res) ->
  line.debug 'AbrGroup Controller', 'Counting abr groups: no params'

  #direct count query, anything is acceptable
  query = req.params

  AbrGroup.count query, (err, found) ->
    if err?
      return handle.error req, res, err, 'Error counting abr groups', 'abrGroupController.count'
    else
      res.send {found}