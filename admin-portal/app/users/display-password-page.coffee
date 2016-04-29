BasePage = require '../base-page'
Template = require './display-password-template.jade'

module.exports = BasePage.extend

  template: Template
  autoRender: yes

  session:
    username: 'string'
    password: 'string'

  events:
    'click [data-hook~=done]': 'done'

  done: () ->
    App.navigate '/users'
