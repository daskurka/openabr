State = require 'ampersand-state'
User = require './user.coffee'
Collection = require 'ampersand-rest-collection'

#the main object of this module
module.exports = State.extend

  typeAttribute: 'currentState'

  children:
    user: User

  session:
    isLoggedIn: { type: 'boolean', default: no, required: yes }
    isAdmin: { type: 'boolean', default: no, required: yes }

  login: (user, isAdmin, callback) ->
    #store the user, find accounts and pick the current account
    @.user = user
    @.isLoggedIn = yes
    @.isAdmin = isAdmin
    callback(null)

  loginUserId: (userId, callback) ->
    #this assumes that server token is already added allowing us to use the api
    u = new User(id: userId)
    u.fetch
      success: (user, response, options) =>
        @.login user, response.isAdmin, callback
      error: (user, response, options) ->
        callback('Error fetching user!')

  logout: () ->
    @.user = null
    @.isLoggedIn = no
    @.isAdmin = no
