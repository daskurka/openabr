async = require 'async'

line = require './line'

Account = require '../controllers/accountModel'
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

          demo =
            name: 'Demo Lab'
            urlName: 'demolab'
            address: 'This is a demo address, as such it is not very long.'
            contact: 'This is a demo contact detail.'
            notes: 'Demo account!'
            suspended: no
            suspendedNotice: ''
            users: []
            admins: []
          demo.admins.push user.id

          Account.create demo, (err) ->
            if err? then return console.log err

            #finally promote the user too system admin
            auth.isAdmin = yes
            auth.save()

            #we are all done!