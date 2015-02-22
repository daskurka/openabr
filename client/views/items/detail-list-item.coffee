View = require 'ampersand-view'
templates = require '../../templates'

async = require 'async'

module.exports = View.extend

  template: templates.includes.items.detailListItem

  render: () ->
    @.renderWithTemplate()

    switch @.model.type
      when 'subject'
        app.services.subject.lookupName @.model.value, (err, name) =>
          @.queryByHook('subject-anchor').innerHTML = name
      when 'experiments'
        experiments = @.model.value
        async.map experiments, app.services.experiment.lookupName, (err, names) =>
          html = ''
          for experiment,i in experiments
            html += "<a href='/experiments/#{experiment}/view'><span class='label label-default'>#{names[i]}</span></a>"
          @.queryByHook('experiments-cell').innerHTML = html

    return @

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