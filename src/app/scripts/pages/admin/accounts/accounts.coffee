PageView = require '../../base.coffee'
templates = require '../../../templates'
AccountView = require '../../../views/items/account.coffee'
AccountsCollection = require '../../../collections/admin/accounts.coffee'

after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'Accounts Administration'
  template: templates.pages.admin.accounts.accounts

  initialize: () ->
    @.collection = new AccountsCollection()

  events:
    'click #newAccount': 'newAccount'
    'keyup [data-hook~=filter]': 'filterAccounts'

  render: () ->
    @.renderWithTemplate(@)
    @.renderCollection(@.collection, AccountView, @.queryByHook('accounts-table'))
    after 500, () =>
      @.collection.query @.queryByHook('filter').value
    return @

  newAccount: () ->
    app.navigate('admin/accounts/create')

  filterAccounts: () ->
    @.collection.query @.queryByHook('filter').value