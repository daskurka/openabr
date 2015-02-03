View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.detailListItem

  derived:
    researcher:
      deps: ['model.value','model.type']
      fn: () ->
        if @.model.type isnt 'user' then return null
        return app.lookup.user(@.model.value).name

    formattedNumber:
      deps: ['model.value','model.type','model.config']
      fn: () ->
        if @.model.type isnt 'number' then return null
        suffix = ''
        if @.model.config?
          if @.model.config.prefix? then suffix += @.model.config.prefix
          if @.model.config.unit? then suffix += @.model.config.unit

        return if suffix.length > 0 then "#{@.model.value} #{suffix}" else @.model.value