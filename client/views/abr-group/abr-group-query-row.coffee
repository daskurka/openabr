View = require 'ampersand-view'
templates = require '../../templates'
_ = require 'lodash'
async = require 'async'

timeFormatter = (rawValue) ->
  value = rawValue / 1000
  return value.toFixed(2)
voltageFormatter = (rawValue) ->
  value = rawValue * 1000000
  return value.toFixed(2)

module.exports = View.extend

  template: templates.views.abrGroups.groupQueryRow

  bindings:
    'datePart': '[data-hook~=date]'
    'joinedTags': '[data-hook~=tags]'
    'model.type': '[data-hook~=type]'
    'model.ear': '[data-hook~=ear]'
    'model.source': '[data-hook~=source]'
    'created': '[data-hook~=created]'
    'creator': '[data-hook~=creator]'

  render: () ->
    @.renderWithTemplate()

    #subject reference
    app.services.subject.lookupName @.model.subjectId, (err, result) =>
      @.queryByHook('subject').innerHTML = result

    #experiment lookup
    async.map @.model.experiments, app.services.experiment.lookupName, (err, result) =>
      html = ''
      for exp in result
        html += "<span class='label label-default'>#{exp}</span>"
      @.queryByHook('experiments').innerHTML = html

    return @

  derived:
    joinedTags:
      deps: ['model.tags']
      fn: () -> @.model.tags.join(', ')
    datePart:
      deps: ['model.date']
      fn: () -> @.model.date.toISOString().split('T')[0]
    created:
      deps: ['model.created']
      fn: () -> @.model.created.toISOString().split('T')[0]
    creator:
      deps: ['model.creator']
      fn: () -> app.lookup.user(@.model.creator).name

  events:
    'click [data-hook~=group-row]': 'handleRowClick'

  handleRowClick: () ->
    app.navigate(@.model.viewUrl)