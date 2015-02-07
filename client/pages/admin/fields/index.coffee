PageView = require '../../base.coffee'
templates = require '../../../templates'

module.exports = PageView.extend

  pageTitle: 'Fields Administration'
  template: templates.pages.admin.fields.index

  initialize: () ->

  events:
    'click #newUser': 'newUser'
    'keyup [data-hook~=filter]': 'filterUsers'