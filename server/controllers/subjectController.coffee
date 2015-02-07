Subject = require '../models/subjectModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'Subject Controller', 'Creating new subject'

  subject = new Subject req.body
  subject.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating subject', 'subjectController.create'
    res.send subject

exports.read = (req, res) ->
  line.debug 'Subject Controller', 'Reading subject: ', req.params.id

  query = Subject.findById req.params.id
  query.exec (err, subject) ->
    if err?
      return handle.error req, res, err, 'Error reading subject', 'subjectController.read'
    else
      res.send subject

exports.update = (req, res) ->
  line.debug 'Subject Controller', 'Updating subject: ', req.params.id

  Subject.findByIdAndUpdate req.params.id, req.body, (err, subject) ->
    if err?
      return handle.error req, res, err, 'Error updating subject', 'subjectController.update'
    else
      res.send subject

exports.remove = (req, res) ->
  line.debug 'Subject Controller', 'Removing subject: ', req.params.id

  # remove user
  Subject.findByIdAndRemove req.params.id, (err, subject) ->
    if err?
      return handle.error req, res, err, 'Error removing subject', 'subjectController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'Subject Controller', 'Querying subjects: no params'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  Subject.find query, null, options, (err, subjects) ->
    if err?
      return handle.error req, res, err, 'Error querying subjects', 'subjectController.query'
    else
      if not isPaged
        return res.send subjects

      #also find total possible records
      Subject.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting subjects', 'subjectController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send subjects

exports.count = (req, res) ->
  line.debug 'Subject Controller', 'Counting subjects: no params'

  #direct count query, anything is acceptable
  query = req.params

  Subject.count query, (err, found) ->
    if err?
      return handle.error req, res, err, 'Error counting subjects', 'subjectController.count'
    else
      res.send {found}