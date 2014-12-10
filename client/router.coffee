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

  #Basic route handlers
  home: () ->
    page = if app.me.isLoggedIn then new pages.Status() else new pages.Home()
    @.trigger 'page', page
  about: () -> @.trigger 'page', new pages.About()
  contact: () -> @.trigger 'page', new pages.Contact()
  login: () -> @.trigger 'page', new pages.Login()
  logout: () -> app.logout()

  #profile handlers
  profile: () -> @.trigger 'page', new pages.profile.View(model: app.me.user)
  editProfile: () -> @.trigger 'page', new pages.profile.Edit(model: app.me.user)
  changePassword: () -> @.trigger 'page', new pages.profile.ChangePassword(model: app.me.user)

  #Admin routes
  adminUsers: () -> @.trigger 'page', new pages.admin.users.Users()
  adminUserCreate: () -> @.trigger 'page', new pages.admin.users.Create()
  adminUserPassword: (passwordState) ->
    @.trigger 'page', new pages.admin.users.Password(model: passwordState)
  adminUserEdit: (user) ->
    @.trigger 'page', new pages.admin.users.Edit({user})

  #Functional routes
  process: () -> console.log 'Process route hit'
  query: () -> console.log 'Query route hit'
  experiments: () -> console.log 'Experiments route hit'
  subjects: () -> console.log 'Subjects route hit'

  #Catch all other routes and head back to home
  catchAll: () -> @.trigger 'page', new pages.FourOhFour()