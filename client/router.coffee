Router = require 'ampersand-router'

pages = require './pages/index.coffee'

module.exports = Router.extend

  routes:
    '': 'home'
    'about': 'about'
    'contact': 'contact'
    'login': 'login'
    'logout': 'logout'
    'profile': 'profile'
    '404': 'catchAll'

    'admin/accounts': 'adminAccounts'
    'admin/accounts/create': 'adminAccountCreate'
    'admin/accounts/:accountName/edit': 'adminAccountEdit'

    'admin/users': 'adminUsers'
    'admin/users/create': 'adminUserCreate'
    'admin/users/:userId/edit': 'adminUserEdit'

    ':accountName': 'accountHome'
    ':accountName/process': 'accountProcess'
    ':accountName/query': 'accountQuery'
    ':accountName/experiments': 'accountExperiments'
    ':accountName/subjects': 'accountSubjects'

    '(*path)': 'catchAll'

  #Basic route handlers
  home: () -> @.trigger 'page', new pages.Home()
  about: () -> @.trigger 'page', new pages.About()
  contact: () -> @.trigger 'page', new pages.Contact()
  login: () -> @.trigger 'page', new pages.Login()
  logout: () -> app.logout()
  profile: () -> console.log 'user profile hit'

  #Admin Routes
  adminAccounts: () -> @.trigger 'page', new pages.admin.accounts.Accounts()
  adminAccountCreate: () -> @.trigger 'page', new pages.admin.accounts.Create()
  adminAccountEdit: (account) ->
    @.trigger 'page', new pages.admin.accounts.Edit({account})

  adminUsers: () -> @.trigger 'page', new pages.admin.users.Users()
  adminUserCreate: () -> @.trigger 'page', new pages.admin.users.Create()
  adminUserEdit: (user) ->
    @.trigger 'page', new pages.admin.users.Edit({user})

  #Account routes
  accountHome: (accountName) ->
    console.log "Account home route for #{accountName} hit..."
    return false
  accountProcess: (accountName) ->
    console.log "Account process route for #{accountName} hit..."
  accountQuery: (accountName) ->
    console.log "Account query route for #{accountName} hit..."
  accountExperiments: (accountName) ->
    console.log "Account experiments route for #{accountName} hit..."
  accountSubjects: (accountName) ->
    console.log "Account subjects route for #{accountName} hit..."

  #Catch all other routes and head back to home
  catchAll: () -> @.trigger 'page', new pages.FourOhFour()