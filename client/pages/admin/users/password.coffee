PageView = require '../../base.coffee'
templates = require '../../../templates'

module.exports = PageView.extend

  pageTitle: 'User Administration'
  template: templates.pages.admin.users.password

  bindings:
    'model.name':
      type: 'text'
      hook: 'name'
    'model.email':
      type: 'text'
      hook: 'email'
    'model.password':
      type: 'text'
      hook: 'password'

  events:
    'click #copyToClipboard': 'copyToClipboard'