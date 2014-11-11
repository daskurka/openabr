View = require 'ampersand-view'
templates = require '../templates'


module.exports = View.extend

  template: templates.navbar

  render: () ->

    @.renderWithTemplate()

    app.me =
      name: 'Samuel Kirkpatrick'
      currentAccount:
        name: 'Ryugo Lab'
        urlName: 'ryugolab'
        isAdmin: yes
      otherAccounts: []
      isSystemAdmin: yes


    if app.me?
      #must be logged on
      do @.logon
    else
      #not logged on
      do @.logoff

    return @


  logoff: () ->
    @.query('.navbar-content').innerHTML = templates.includes.navbar.loggedout()

  logon: () ->
    @.query('.navbar-content').innerHTML = templates.includes.navbar.loggedin(app.me)