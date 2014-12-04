async = require 'async'

line = require './line'

User = require '../controllers/userModel'
authenticate = require './authenticate'

module.exports = (server) ->

  #first run condition is simple, there should be a user
  User.count {}, (err, userCount) ->
    if err? then return console.log err

    if userCount <= 0
      #create admin
      admin =
        name: 'Samuel Kirkpatrick'
        email: 'admin@openabr.com'
        position: 'Administrator'
      User.create admin, (err, user) ->
        if err? then return console.log err

        authenticate.createAuthentication user.id, 'password', (err, auth) ->
          if err? then return console.log err

          auth.isAdmin = yes
          auth.save () ->

            #we are all done!