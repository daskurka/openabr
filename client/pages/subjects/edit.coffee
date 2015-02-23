Base = require '../edit-base.coffee'
templates = require '../../templates'

SubjectModel = require '../../models/core/subject.coffee'

module.exports = Base.extend

  pageTitle: 'Edit Subject'
  template: templates.pages.subjects.edit

  initialize: (spec) ->
    subject = new SubjectModel(id: spec.id)
    subject.fetch
      success: (model) =>
        @.loadFieldsAndModel('subject', model)

  afterSave: () ->
    app.navigate(@.model.viewUrl)

  cancel: () ->
    app.navigate(@.model.viewUrl)