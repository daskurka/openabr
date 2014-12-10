PageView = require '../base.coffee'
templates = require '../../templates'

module.exports = PageView.extend

  pageTitle: 'View Profile'
  template: templates.pages.profile.view

  bindings:
    'model.name':
      type: 'text'
      hook: 'name'
    'model.email':
      type: 'text'
      hook: 'email'
    'model.position':
      type: 'text'
      hook: 'position'
    'model.id':
      type: 'text'
      hook: 'id'

  events:
    'click #edit': 'edit'
    'click #changePassword': 'changePassword'

  edit: () ->
    app.navigate('/profile/edit')

  changePassword: () ->
    app.navigate('/profile/change-password')

