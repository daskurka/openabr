Router = require 'ampersand-router'



module.exports = Router.extend

  routes:
    '': 'home'

    'users': 'listUsers'
    'users/create': 'createUser'

    '(*path)': 'fourOhFour'

  showPage: (page) -> @.trigger 'page', page

  home: () ->
    console.log 'home'

  listUsers: () -> @.showPage new (require("./users/users-view"))({})
  createUser: () -> @.showPage new (require("./users/create-user-view"))({})

  fourOhFour: () ->
    console.log '404'
