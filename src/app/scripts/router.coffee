Router = require 'ampersand-router'



class OpenAbrRouter extends Router

  routes:
    '': 'home'
    'about': 'about'
    'login': 'login'

  home: () ->
    console.log 'home route'

  about: () ->
    console.log 'about route'

  login: () ->
    console.log 'login route'



module.exports = OpenAbrRouter