PageView = require '../../base.coffee'
templates = require '../../../templates'

module.exports = PageView.extend

  pageTitle: 'Accounts Administration'
  template: templates.pages.admin.accounts.accounts

  events:
    'click #newAccount': 'newAccount'
    'keyup #filterAccounts': 'filterAccounts'

  newAccount: () -> app.navigate('admin/accounts/create')
  filterAccounts: () -> console.log 'filter accounts hit'