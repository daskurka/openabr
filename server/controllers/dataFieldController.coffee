DataField = require '../models/dataFieldModel'
line = require '../utils/line'
handle = require '../utils/handleError'
pager = require '../utils/pager'

exports.create = (req, res) ->
  line.debug 'DataField Controller', 'Creating new dataField'

  dataField = new DataField req.body
  dataField.save (err) ->
    if err?
      return handle.error req, res, err, 'Error creating dataField', 'dataFieldController.create'
    res.send dataField

exports.read = (req, res) ->
  line.debug 'DataField Controller', 'Reading dataField: ', req.params.id

  console.log req.params

  query = DataField.findById req.params.id
  query.exec (err, dataField) ->
    if err?
      return handle.error req, res, err, 'Error reading dataField', 'dataFieldController.read'
    else
      res.send dataField

exports.update = (req, res) ->
  line.debug 'DataField Controller', 'Updating dataField: ', req.params.id

  DataField.findByIdAndUpdate req.params.id, req.body, (err, dataField) ->
    if err?
      return handle.error req, res, err, 'Error updating dataField', 'dataFieldController.update'
    else
      res.send dataField

exports.remove = (req, res) ->
  line.debug 'DataField Controller', 'Removing dataField: ', req.params.id

  # remove user
  DataField.findByIdAndRemove req.params.id, (err, dataField) ->
    if err?
      return handle.error req, res, err, 'Error removing dataField', 'dataFieldController.remove'
    else
      res.status(200)
      do res.send

exports.query = (req, res) ->
  line.debug 'DataField Controller', 'Querying dataFields: ', req.params.col

  #check for pagination
  {query, options, isPaged} = pager.filterQuery(req.params)

  #query all
  DataField.find query, null, options, (err, dataFields) ->
    if err?
      return handle.error req, res, err, 'Error querying dataFields', 'dataFieldController.query'
    else
      if not isPaged
        return res.send dataFields

      #also find total possible records
      DataField.count query, (err, totalFound) ->
        if err?
          return handle.error req, res, err, 'Error counting dataFields', 'dataFieldController.query'
        else
          pager.attachResponseHeaders(res, totalFound)
          res.send dataFields

exports.checkDbName = (req, res) ->
  line.debug 'DataField Controller', 'Checking if field dbName already exists: ', req.params.dbName

  DataField.findOne {dbName: req.params.dbName, col: req.params.colName}, (err, dataField) ->
    if err?
      return handle.error req, res, err, 'Error checking data field', 'userAdminController.checkDbName'
    else
      if dataField?
        return res.send {exists: true}
      else
        return res.send {exists: false}