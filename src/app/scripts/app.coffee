#linking in jquery and bootstrap here
window.$ = window.jQuery = require 'jquery'
bootstrap = require 'bootstrap'

Model = require 'ampersand-model'

domReady = require 'domready'

templates = require './templates'
Router = require './router.coffee'
MainView = require './views/main.coffee'

Current = require './models/current.coffee'

module.exports =

  #main app function
  start: () ->
    window.app = @

    #init the router
    @.router = new Router()

    #setup token routing
    #TODO check cookie for token
    app.serverToken = null

    #all ajax request should have token attached if it exists
    $(document).ajaxSend (event, request, options) ->
      token = app.serverToken
      if token?
        request.setRequestHeader 'token', token

    #if error comes and it is 401 then redirect to login page
    $(document).ajaxError (event, response) ->
      if response.status is 401
        app.navigate 'login'

    #after EVERYTHING is loading, run our first view
    domReady () =>

      #create empty user state
      @.me = new Current()

      #create main view and render
      @.view = new MainView({el: document.body})
      do @.view.render

      #start router history at /
      @.router.history.start {pushState: yes, root: '/'}

  logout: () ->
    @.me.logout()
    @.view.trigger 'logout'
    @.navigate ''

  login: (email, password, remember, callback) ->
    @.me.logout()
    $.ajax
      type: 'GET'
      url: 'api/auth/login'
      data: {email, password}
      dataType: 'json'
      success: (response) =>
        app.serverToken = response.token
        @.me.login response.user, response.isSystemAdmin, (err) =>
          if err?
            @.me.logout()
            callback(err)
          else
            @.view.trigger 'login'
            app.navigate @.me.currentAccount.urlName
            callback(null, true)
      error: (response) ->
        if response.status is 401
          callback(null,false)
        else
          callback(response.responseText)


  navigate: (page) ->
    url = if page.charAt(0) is '/' then page.slice(1) else page
    @.router.history.navigate url, {trigger: yes}

# run
do module.exports.start
