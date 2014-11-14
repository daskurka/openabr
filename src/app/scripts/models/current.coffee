State = require 'ampersand-state'
User = require './user.coffee'
Account = require './account/account.coffee'
Collection = require 'ampersand-rest-collection'

#this should contain a bunch of related accounts and needs to hit a speical url
OtherAccountsCollection = Collection.extend

  ajaxConfig: () -> {headers: {token: app.serverToken}}

  url: () -> "/api/profile/#{@userId}/accounts"
  model: Account

  userId: null

#the main object of this module
module.exports = State.extend

  typeAttribute: 'currentState'

  children:
    user: User
    currentAccount: Account

  collections:
    otherAccounts: OtherAccountsCollection

  session:
    isLoggedIn: { type: 'boolean', default: no, required: yes }
    isSystemAdmin: { type: 'boolean', default: no, required: yes }

  login: (user, isSysAdmin, callback) ->
    #store the user, find accounts and pick the current account
    @.user = user
    @.otherAccounts = new OtherAccountsCollection()
    @.otherAccounts.userId = @.user.id
    @.otherAccounts.fetch
      success: (collection, response, options) =>
        @.currentAccount = collection.first()
        @.isLoggedIn = yes
        @.isSystemAdmin = isSysAdmin
        callback(null)

      error: (collection, response, options) ->
        callback('Error fetching accounts!')

  loginUserId: (userId, callback) ->
    #this assumes that server token is already added allowing us to use the api
    u = new User()
    u.id = userId
    u.fetch
      success: (user, response, options) =>
        @.login user, response.isSystemAdmin, callback
      error: (user, response, options) ->
        callback('Error fetching user!')

  logout: () ->
    @.user = null
    @.currentAccount = null
    @.otherAccounts = []
    @.isLoggedIn = no
    @.isSystemAdmin = no
