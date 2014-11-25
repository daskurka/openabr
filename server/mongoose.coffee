mongoose = require 'mongoose'

module.exports = (server) ->

  #connect to db
  mongoose.connect('mongodb://localhost/dev')

  #models!
  require('./controllers/accountModel')
  require('./controllers/userModel')
  require('./utils/authModel')