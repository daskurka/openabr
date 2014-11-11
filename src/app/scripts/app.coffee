#linking in jquery and bootstrap here
window.$ = window.jQuery = require 'jquery'
bootstrap = require 'bootstrap'

Model = require 'ampersand-model'

domReady = require 'domready'

templates = require './templates'
Router = require './router.coffee'
MainView = require './views/main.coffee'


module.exports =

  #main app function
  start: () ->
    window.app = @

    #init the router
    @.router = new Router()

    #after EVERYTHING is loading, run our first view
    domReady () =>

      #create first view and render it
      Me = Model.extend
        props:
          firstName: 'string'
          lastName: 'string'
      me = new Me({firstName: 'sam', lastName: 'kirka'})

      #console.log me
      @.view = new MainView({el: document.body, model: me})
      do @.view.render

      #start router history at /
      @.router.history.start {pushState: yes, root: '/'}


  navigate: (page) ->
    url = if page.charAt(0) is '/' then page.slice(1) else page
    @.router.history.navigate url, {trigger: yes}

# run
do module.exports.start
