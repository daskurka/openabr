Collection = require 'ampersand-rest-collection'
UserModel = require './user-model.coffee'


module.exports = Collection.extend

  model: UserModel

  refresh: () ->
    console.log 'refresh called.'
