Router = require 'ampersand-router'

HomePage = require './pages/home.coffee'
AboutPage = require './pages/about.coffee'
ContactPage = require './pages/contact.coffee'
LoginPage = require './pages/login.coffee'

AccountsPage = require './pages/admin/accounts.coffee'


module.exports = Router.extend

  routes:
    '': 'home'
    'about': 'about'
    'contact': 'contact'
    'login': 'login'
    'logout': 'logout'
    'profile': 'profile'

    'admin/accounts': 'accounts'

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
  logout: () -> console.log 'logout hit'
  profile: () -> console.log 'user profile hit'

  #Admin Routes
  accounts: () -> @.trigger 'page', new AccountsPage()

  #Account routes
  accountHome: (accountName) -> console.log "Account home route for #{accountName} hit..."
  accountProcess: (accountName) -> console.log "Account process route for #{accountName} hit..."
  accountQuery: (accountName) -> console.log "Account query route for #{accountName} hit..."
  accountExperiments: (accountName) -> console.log "Account experiments route for #{accountName} hit..."
  accountSubjects: (accountName) -> console.log "Account subjects route for #{accountName} hit..."

  #Catch all other routes and head back to home
  catchAll: () ->
    console.log 'catch all hit'
    @.redirectTo('')