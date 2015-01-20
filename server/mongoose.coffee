mongoose = require 'mongoose'

module.exports = (server) ->

  #connect to db
  mongoose.connect(server.get('mongo'))

  #models!
  require('./models/userModel')
  require('./models/authModel')
  require('./models/dataFieldModel')
  require('./models/experimentModel')
  require('./models/subjectModel')
  require('./models/abrModel')