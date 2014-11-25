PagedCollection = require '../paged.coffee'
Account = require '../../models/admin/account.coffee'

module.exports = PagedCollection.extend
  model: Account
  url: '/api/admin/accounts'
  typeAttribute: 'adminAccountsCollection'

  query: (textSearch) ->
    data = {name: {$regex: "#{textSearch}", $options: 'i'} }
    @.queryPaged(1,15,data)