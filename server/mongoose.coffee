mongoose = require 'mongoose'

module.exports = (server) ->

  #connect to db
  mongoose.connect(server.get('mongo'))

  #models!
  require('./controllers/userModel')
  require('./utils/authModel')