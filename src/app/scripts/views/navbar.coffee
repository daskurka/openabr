View = require 'ampersand-view'
templates = require '../templates'


module.exports = View.extend

  template: templates.navbar

  initialize: () ->
    @.listenTo app.view, 'login', @logon
    @.listenTo app.view, 'logout', @logoff

  render: () ->
    @.renderWithTemplate()

    if app.me.isLoggedIn then do @.logon else do @.logoff

    return @

  logoff: () ->
    @.query('.navbar-content').innerHTML = templates.includes.navbar.loggedout()

  logon: () ->
    @.query('.navbar-content').innerHTML = templates.includes.navbar.loggedin(app.me)