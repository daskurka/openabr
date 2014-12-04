PageView = require './base.coffee'
templates = require '../templates'

module.exports = PageView.extend

  pageTitle: 'Status'
  template: templates.pages.status