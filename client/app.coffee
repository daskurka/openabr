#linking in jquery and bootstrap here
window.$ = window.jQuery = require 'jquery'
bootstrap = require 'bootstrap'
domReady = require 'domready'
Cookies = require 'cookies-js'

templates = require './templates'
Router = require './router.coffee'
MainView = require './views/main.coffee'
Current = require './models/current.coffee'

module.exports =

  #i have to get the sequence correct for this
  startRouter: () ->
    #start router history at / - after the point the application will start to route
    @.router.history.start {pushState: yes, root: '/'}

  #main app function
  start: () ->
    #configure globals
    window.app = @
    do configureAjax #setup ajax calls

    #waits for page to fully load then shows first view
    domReady () =>
      @.router = new Router() #init the router
      @.me = new Current() #create empty user state

      #create main view and render
      @.view = new MainView({el: document.body})
      do @.view.render

      #handle cookie token login if allowed
      if Cookies.enabled and Cookies.get('rememberMe')
        app.serverToken = Cookies.get('serverToken')
        userId = Cookies.get('userId')
        @.me.loginUserId userId, (err) =>
          if err? then return do @.logout
          @.view.trigger 'login'
          if window.location.length <= 0
            app.navigate ''
          @.startRouter()
      else
        @.startRouter()



  #logout the current user from anywhere
  logout: () ->
    @.me.logout()
    Cookies.expire 'rememberMe'
    Cookies.expire 'serverToken'
    Cookies.expire 'userId'
    @.view.trigger 'logout'
    @.navigate ''

  #login a new user from anywhere
  login: (email, password, remember, callback) ->
    @.me.logout()
    $.ajax
      type: 'GET'
      url: 'api/auth/login'
      data: {email, password}
      dataType: 'json'
      success: (response) =>
        app.serverToken = response.token
        if remember and Cookies.enabled
          cookieConfig = {expires: 604800} #7 days in seconds
          Cookies.set 'rememberMe', true, cookieConfig
          Cookies.set 'serverToken', app.serverToken, cookieConfig
          Cookies.set 'userId', response.user.id, cookieConfig
        @.me.login response.user, response.isAdmin, (err) =>
          if err?
            @.me.logout()
            callback(err)
          else
            @.view.trigger 'login'
            app.navigate ''
            callback(null, true)
      error: (response) ->
        if response.status is 401
          callback(null,false)
        else
          callback(response.responseText)

  #navigate to a different page from anywhere
  navigate: (page) ->
    url = if page.charAt(0) is '/' then page.slice(1) else page
    @.router.history.navigate url, {trigger: yes}

#configure ajax (ampersand models and collections are configured themselves)
configureAjax = () ->
  #all ajax request should have token attached if it exists
  $(document).ajaxSend (event, request, options) ->
    token = app.serverToken
    if token?
      request.setRequestHeader 'token', token

  #if error comes and it is 401 then redirect to login page
  $(document).ajaxError (event, response) ->
    if response.status is 401
      app.navigate 'login'

# run
do module.exports.start
