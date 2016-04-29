#load custom styles
require("./app.styl")

#start logger
Logger = require('./logger')
logger = new Logger()
window.log = logger.log
log.trace "Starting admin-portal"

#configure ampersand application
Application = require 'ampersand-app'

#first view and router
MainView = require './main-view'
Router = require './router'

#error view
ErrorPage = require './error/page'


#global application container
window.App = Application.extend

  router: new Router()
  baseUrl: "/admin"
  logger: logger

  init: () ->
    log.trace "Starting app initialisation..."

    #setup main page and nav container
    mainView = new MainView()
    document.body.appendChild(mainView.el)

    #startt application
    @.router.history.start({pushState: yes, root: @.baseUrl})
    log.info "Admin-Portal ready."

  navigate: (page) ->
    log.trace "Navigating to page: #{page}"
    url = if (page.charAt(0) is '/') then page.slice(1) else page
    @.router.history.navigate(url, {trigger: yes})

  handleError: (redirect, report, error, reason) ->
    log.trace "Handling error: #{error}"
    page = new ErrorPage({error, reason, report, redirect})
    @.router.trigger 'page', page

#start the app
do $.proxy(App.init,App)
