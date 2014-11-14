PageView = require '../base.coffee'
templates = require '../../templates'

module.exports = PageView.extend

  pageTitle: 'Accounts Administration'
  template: templates.pages.admin.accounts

  events:
    'click #newAccount': 'newAccount'
    'keyup #filterAccounts': 'filterAccounts'

  newAccount: () -> console.log 'new account hit'
  filterAccounts: () -> console.log 'filter accounts hit'