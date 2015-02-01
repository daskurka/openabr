View = require 'ampersand-view'
templates = require '../../templates'

module.exports = View.extend

  template: templates.includes.items.subject

  bindings:
    'model.reference': '[data-hook~=reference]'
    'model.strain': '[data-hook~=strain]'
    'model.species': '[data-hook~=species]'
    'model.textDob': '[date-hook~=dob]'
    'model.textDod': '[date-hook~=dod]'
    'model.experiments': '[date-hook~=experiments]'

  events:
    'click [data-hook~=subject-row]': 'handleRowClick'

  handleRowClick: () ->
    #app.navigate(@.model.editUrl)
    alert 'you totes clicked a row!!!!'