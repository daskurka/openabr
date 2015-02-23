View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.views.upload.confirmReviewView

  render: () ->
    @.renderWithTemplate()

    @.renderQuickView()

    return @

  renderQuickView: () ->
    html = ''
    @.model.groups.each (group) ->
      html += "<h4>#{group.name}<small> #{group.type}</small></h4>"
      html += "<div class='list-group'>"
      group.sets.each (set) ->
        threshold = set.analysis?.threshold?.level
        text = if threshold? then (if threshold isnt -1 then threshold + ' dB' else 'No Response') else 'Not Complete'

        html += "<a class='list-group-item'>"
        html += "<h4 class='list-group-item-heading'>#{set.nameHtml}</h4>"
        html += "<p class='list-group-item-text'>#{set.readings.length} readings - Threshold: #{text}</p>"
        html += "</a>"
      html += "</div>"

    @.query('#quick-details').innerHTML = html

