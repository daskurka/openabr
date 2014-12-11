Router = require 'ampersand-router'

pages = require './pages/index.coffee'

module.exports = Router.extend

  routes:
    '': 'home'
    'about': 'about'
    'contact': 'contact'
    'login': 'login'
    'logout': 'logout'
    '404': 'catchAll'
    '401': 'unauthorized'

    'profile': 'profile'
    'profile/edit': 'editProfile'
    'profile/change-password': 'changePassword'

    'admin/users': 'adminUsers'
    'admin/users/create': 'adminUserCreate'
    'admin/users/:userId/edit': 'adminUserEdit'

    'process': 'process'
    'query': 'query'
    'experiments': 'experiments'
    'treatments': 'experiments'
    'subjects': 'subjects'
    'patients': 'subjects'

    '(*path)': 'catchAll'

  #helpers
  showPage: (page) ->
    @.trigger 'page', page

  showUserPage: (page) ->
    if app.me.isLoggedIn then @.showPage page else do @.login

  showAdminPage: (page) ->
    if app.me.isAdmin then @.showUserPage page else do @.unauthorized

  #Basic route handlers
  home: () ->
    if app.me.isLoggedIn
      @.showUserPage new pages.Status()
    else
      @.showPage new pages.Home()

  about: () ->
    @.showPage new pages.About()

  contact: () ->
    @.showPage new pages.Contact()

  login: () ->
    @.showPage new pages.Login()

  logout: () ->
    app.logout()
    @.showPage new pages.Home()

  unauthorized: () ->
    @.showPage new pages.FourOhOne()

  #profile handlers
  profile: () ->
    console.log app.me.user
    @.showUserPage new pages.profile.View(model: app.me.user)

  editProfile: () ->
    @.showUserPage new pages.profile.Edit(model: app.me.user)

  changePassword: () ->
    @.showUserPage new pages.profile.ChangePassword(model: app.me.user)

  #Admin routes
  adminUsers: () ->
    @.showAdminPage new pages.admin.users.Users()

  adminUserCreate: () ->
    @.showAdminPage new pages.admin.users.Create()

  adminUserPassword: (passwordState) ->
    @.showAdminPage new pages.admin.users.Password(model: passwordState)

  adminUserEdit: (user) ->
    @.showAdminPage new pages.admin.users.Edit({user})

  #Functional routes
  process: () ->
    console.log 'Process route hit'

  query: () ->
    console.log 'Query route hit'

  experiments: () ->
    console.log 'Experiments route hit'

  subjects: () ->
    console.log 'Subjects route hit'

  #Catch all other routes and head back to home
  catchAll: () ->
    @.showPage new pages.FourOhFour()