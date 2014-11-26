PagedCollection = require '../paged.coffee'
User = require '../../models/admin/user.coffee'

module.exports = PagedCollection.extend
  model: User
  url: '/api/admin/users'
  typeAttribute: 'adminUserCollection'

  query: (textSearch) ->
    data = {name: {$regex: "#{textSearch}", $options: 'i'} }
    @.queryPaged(1,15,data)