View = require 'ampersand-view'
templates = require '../../templates'
select2 = require 'select2'

module.exports = View.extend

  template: templates.views.upload.sigGen

  props:
      lines: 'array'

  initialize: () ->
    console.log @.lines[0]
