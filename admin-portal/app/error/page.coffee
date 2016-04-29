BasePage = require '../base-page'
Template = require './template.jade'


module.exports = BasePage.extend
  template: Template

  session:
    error: 'string'
    reason: 'string'
    redirect: 'string'
    report: ['boolean',yes,no]

  bindings:
    'report':
      type: 'toggle'
      hook: 'report'

  events:
    'click [data-hook~=next]': 'next'
    'click [data-hook~=generate-report]': 'generateReport'

  next: () ->
    App.navigate @.redirect

  generateReport: () ->
    report =
      date: Date.now()
      logs: App.logger.logs
    window.href = "data:plain/text," + JSON.stringify(report)
