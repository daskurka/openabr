mongoose = require 'mongoose'
line = require '../utils/line'
handle = require '../utils/handleError'
async = require 'async'
_ = require 'lodash'

AbrSet = require '../models/abrSetModel'
AbrReading = require '../models/abrReadingModel'
AbrGroup = require '../models/abrGroupModel'

exports.getUniqueAbrTags = (req, res) ->
  line.debug 'Tagging Utility', 'Getting Unique Abr Tags'

  async.parallel [
    (cb) -> AbrSet.distinct 'tags', cb
    (cb) -> AbrReading.distinct 'tags', cb
    (cb) -> AbrGroup.distinct 'tags', cb
  ], (err, tagsArray) ->
    if err?
      return handle.error req, res, err, 'Error getting unique abr tags', 'utils.tagging.getUniqueAbrTags'
    else
      tags = _.union(tagsArray[0],tagsArray[1],tagsArray[2])
      res.send tags


