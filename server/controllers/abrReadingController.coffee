AbrReading = require '../models/abrReadingModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'AbrReading Controller', 'Creating new abr reading'

  abrReading = new AbrReading req.body
  abrReading.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating abr reading', 'abrReadingController.create'
    res.send abrReading

exports.read = (req, res) ->
  line.debug 'AbrReading Controller', 'Reading abr reading: ', req.params.id

  query = AbrReading.findById req.params.id
  query.exec (err, abrReading) ->
    if err?
      return handle.error req, res, err, 'Error reading abr reading', 'abrReadingController.read'
    else
      res.send abrReading

exports.update = (req, res) ->
  line.debug 'AbrReading Controller', 'Updating abr reading: ', req.params.id

  AbrReading.findByIdAndUpdate req.params.id, req.body, (err, abrReading) ->
    if err?
      return handle.error req, res, err, 'Error updating abr reading', 'abrReadingController.update'
    else
      res.send abrReading

exports.remove = (req, res) ->
  line.debug 'AbrReading Controller', 'Removing abr reading: ', req.params.id

  AbrReading.findByIdAndRemove req.params.id, (err, abrReading) ->
    if err?
      return handle.error req, res, err, 'Error removing abr reading', 'abrReadingController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'AbrReading Controller', 'Querying abr readings: no params'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  AbrReading.find query, null, options, (err, abrReadings) ->
    if err?
      return handle.error req, res, err, 'Error querying abr readings', 'abrReadingController.query'
    else
      if not isPaged
        return res.send abrReadings

      #also find total possible records
      AbrReading.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting abr readings', 'abrReadingController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send abrReadings

exports.count = (req, res) ->
  line.debug 'AbrReading Controller', 'Counting abr readings: no params'

  #direct count query, anything is acceptable
  query = req.params

  AbrReading.count query, (err, found) ->
    if err?
      return handle.error req, res, err, 'Error counting abr readings', 'abrReadingController.count'
    else
      res.send {found}