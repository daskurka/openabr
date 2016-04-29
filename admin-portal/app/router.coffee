Router = require 'ampersand-router'



module.exports = Router.extend

  routes:
    '': 'home'

    'users': 'listUsers'
    'users/create': 'createUser'
    'users/:username': 'editUser'

    '(*path)': 'fourOhFour'

  showPage: (page) -> @.trigger 'page', page
  showPageWithModel: (Page, Model, id) ->
    modelInstance = new Model({_id: id})
    modelInstance.fetch
      success: (model) =>
        @.trigger 'page', new Page({model})
      error: (model, response) ->
        log.error "Unexpected error while trying to load model for for page."


  home: () ->
    console.log 'home'

  listUsers: () -> @.showPage new (require("./users/users-view"))({})
  createUser: () -> @.showPage new (require("./users/create-user-view"))({})
  editUser: (username) -> @.showPageWithModel require('./users/edit-page'), require("./users/user-model"), "org.couchdb.user:" + username

  fourOhFour: () ->
    console.log '404'
