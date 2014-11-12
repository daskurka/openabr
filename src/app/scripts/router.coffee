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
    'admin/accounts': 'accounts'
    '(*path)': 'catchAll'

  home: () ->
    @.trigger('page', new HomePage())

  about: () ->
    @.trigger 'page', new AboutPage()

  contact: () ->
    @.trigger 'page', new ContactPage()

  login: () ->
    @.trigger 'page', new LoginPage()

  logout: () ->
    console.log 'logout hit'

  accounts: () ->
    @.trigger 'page', new AccountsPage()

  catchAll: () ->
    console.log 'catch all hit'
    @.redirectTo('')