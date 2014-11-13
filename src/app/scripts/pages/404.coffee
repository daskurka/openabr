PageView = require './base.coffee'
templates = require '../templates'

module.exports = PageView.extend

  pageTitle: 'Login'
  template: templates.pages['404']