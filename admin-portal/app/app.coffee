#load custom styles
require("./app.styl")

#configure ampersand application
Application = require 'ampersand-app'

#first view and router
MainView = require './main-view'
Router = require './router'


#global application container
window.App = Application.extend

  router: new Router()

  init: () ->

    #setup main page and nav container
    mainView = new MainView()
    document.body.appendChild(mainView.el)

    #startt application
    @.router.history.start({pushState: yes, root: "/admin"})

  navigate: (page) ->
    console.log "Navigating to page: #{page}"
    url = if (page.charAt(0) is '/') then page.slice(1) else page
    @.router.history.navigate(url, {trigger: yes})

#start the app
do $.proxy(App.init,App)
