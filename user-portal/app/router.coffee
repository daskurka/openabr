Router = require 'ampersand-router'



module.exports = Router.extend

  routes:
    '': 'home'
    '(*path)': 'fourOhFour'

  showPage: (page) -> @.trigger 'page', page

  home: () ->
    console.log 'home'

  fourOhFour: () ->
    console.log '404'
