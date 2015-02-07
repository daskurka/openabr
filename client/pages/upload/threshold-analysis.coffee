PageView = require './../base.coffee'
templates = require '../../templates'

ViewSwitcher = require 'ampersand-view-switcher'


module.exports = PageView.extend

  pageTitle: 'Threshold Analysis'
  template: templates.pages.upload.thresholdAnalysis

  initialize: () ->
    console.log @.model.groups.length
    console.log @.model.groups.models[0].sets.length

