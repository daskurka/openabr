PageView = require './base.coffee'
templates = require '../templates'

module.exports = PageView.extend

  pageTitle: 'Not Found'
  template: templates.pages['404']