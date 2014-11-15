Router = require 'ampersand-router'

HomePage = require './pages/home.coffee'
AboutPage = require './pages/about.coffee'
ContactPage = require './pages/contact.coffee'
LoginPage = require './pages/login.coffee'
FourOhFourPage = require './pages/404.coffee'

AdminAccountsPage = require './pages/admin/accounts/accounts.coffee'
AdminAccountCreate = require './pages/admin/accounts/create.coffee'
AdminUsersPage = require './pages/admin/users/users.coffee'


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
    'admin/users': 'adminUsers'
    ':accountName': 'accountHome'
    ':accountName/process': 'accountProcess'
    ':accountName/query': 'accountQuery'
    ':accountName/experiments': 'accountExperiments'
    ':accountName/subjects': 'accountSubjects'
    '(*path)': 'catchAll'

  #Basic route handlers
  home: () -> @.trigger 'page', new HomePage()
  about: () -> @.trigger 'page', new AboutPage()
  contact: () -> @.trigger 'page', new ContactPage()
  login: () -> @.trigger 'page', new LoginPage()
  logout: () -> app.logout()
  profile: () -> console.log 'user profile hit'

  #Admin Routes
  adminAccounts: () -> @.trigger 'page', new AdminAccountsPage()
  adminAccountCreate: () -> @.trigger 'page', new AdminAccountCreate()
  adminUsers: () -> @.trigger 'page', new AdminUsersPage()

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
  catchAll: () -> @.trigger 'page', new FourOhFourPage()