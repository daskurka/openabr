PageView = require '../../base.coffee'
templates = require '../../../templates'

module.exports = PageView.extend

  pageTitle: 'User Administration'
  template: templates.pages.admin.users.users