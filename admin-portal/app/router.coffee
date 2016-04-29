Router = require 'ampersand-router'



module.exports = Router.extend

  routes:
    '': 'home'

    'users': 'listUsers'
    'users/create': 'createUser'
    'users/:username': 'editUser'

    'logout': 'logout'

    '(*path)': 'fourOhFour'

  showPage: (page) -> @.trigger 'page', page
  showPageWithModel: (Page, Model, id) ->
    modelInstance = new Model({_id: id})
    modelInstance.fetch
      success: (model) =>
        @.trigger 'page', new Page({model})
      error: (model, response) ->
        log.error "Unexpected error while trying to load model for for page."


  home: () -> @.showPage new (require('./home/page'))({})
  listUsers: () -> @.showPage new (require("./users/users-view"))({})
  createUser: () -> @.showPage new (require("./users/create-user-view"))({})
  editUser: (username) -> @.showPageWithModel require('./users/edit-page'), require("./users/user-model"), "org.couchdb.user:" + username

  fourOhFour: () ->
    log.error "Requested unknown application path: #{window.href}"
    log.trace "Redirecting to Home"
    App.navigate '/'

  logout: () ->
    options =
      url: App.baseUrl + "/data/_session"
      method: "DELETE"
    $.ajax(options)
      .fail () ->
        log.error "Error trying to logout user."
        return @.redirectTo('')
      .done () ->
        log.info "User logged out"
        window.location.href = App.baseUrl + "/#/"
