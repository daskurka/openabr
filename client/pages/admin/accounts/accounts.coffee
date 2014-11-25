PageView = require '../../base.coffee'
templates = require '../../../templates'
AccountView = require '../../../views/items/account.coffee'
AccountsCollection = require '../../../collections/admin/accounts.coffee'
State = require 'ampersand-state'
PagerView = require '../../../views/pager.coffee'
PagerState = require '../../../configurations/pager.coffee'

after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'Accounts Administration'
  template: templates.pages.admin.accounts.accounts

  initialize: () ->
    @.collection = new AccountsCollection()
    @.pager = new PagerView(model: new PagerState(collection: @.collection))

  events:
    'click #newAccount': 'newAccount'
    'keyup [data-hook~=filter]': 'filterAccounts'

  render: () ->
    #render everything
    @.renderWithTemplate(@)
    @.renderCollection(@.collection, AccountView, @.queryByHook('accounts-table'))
    @.renderSubview(@.pager, @.queryByHook('pagination-control'))

    after 500, () => @.filterAccounts()
    return @

  newAccount: () ->
    app.navigate('admin/accounts/create')

  filterAccounts: () ->
    @.collection.query @.queryByHook('filter').value