PageView = require './base.coffee'
templates = require '../templates'

module.exports = PageView.extend

  pageTitle: 'Unauthorized'
  template: templates.pages['401']