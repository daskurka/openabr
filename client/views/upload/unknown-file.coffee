View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.views.upload.unknownFile

  props:
    lines: 'array'