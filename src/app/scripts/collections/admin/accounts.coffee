Collection = require '../base.coffee'
Account = require '../../models/admin/account.coffee'

module.exports = Collection.extend
  model: Account
  url: '/api/admin/accounts'
  typeAttribute: 'adminAccountsCollection'

  query: (textSearch) ->
    @.fetch
      data: {name: {$regex: "#{textSearch}", $options: 'i'} }