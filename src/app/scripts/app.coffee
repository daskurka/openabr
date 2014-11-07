$ = require 'jquery'
domReady = require 'domready'

templates = require './templates'
Router = require './router.coffee'
MainView = require './views/main.coffee'



module.exports =

  start: () ->
    window.app = @

    @.router = new Router()

    domReady () =>

      @.view = new MainView
        el: document.body

      do @.view.render

      @.router.history.start {pushState: yes, root: '/'}


  navigate: (page) ->
    url = if page.charAt(0) is '/' then page.slice(1) else page
    @.router.history.navigate url, {trigger: yes}


#gogogogo
do module.exports.start
