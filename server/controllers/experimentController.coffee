Experiment = require '../models/experimentModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'Experiment Controller', 'Creating new experiment'

  experiment = new Experiment req.body
  experiment.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating experiment', 'experimentController.create'
    res.send experiment

exports.read = (req, res) ->
  line.debug 'Experiment Controller', 'Reading experiment: ', req.params.id

  query = Experiment.findById req.params.id
  query.exec (err, experiment) ->
    if err?
      return handle.error req, res, err, 'Error reading experiment', 'experimentController.read'
    else
      res.send experiment

exports.update = (req, res) ->
  line.debug 'Experiment Controller', 'Updating experiment: ', req.params.id

  Experiment.findByIdAndUpdate req.params.id, req.body, (err, experiment) ->
    if err?
      return handle.error req, res, err, 'Error updating experiment', 'experimentController.update'
    else
      res.send experiment

exports.remove = (req, res) ->
  line.debug 'Experiment Controller', 'Removing experiment: ', req.params.id

  # remove user
  Experiment.findByIdAndRemove req.params.id, (err, experiment) ->
    if err?
      return handle.error req, res, err, 'Error removing experiment', 'experimentController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'Experiment Controller', 'Querying experiment: no params'

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  Experiment.find query, null, options, (err, experiments) ->
    if err?
      return handle.error req, res, err, 'Error querying experiments', 'experimentController.query'
    else
      if not isPaged
        return res.send experiments

      #also find total possible records
      Experiment.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting experiments', 'experimentController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send experiments