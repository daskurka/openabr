User = require '../user.coffee'

module.exports = User.extend

  typeAttribute: 'adminUserModel'
  urlRoot: '/api/admin/users'

  derived:
    editUrl:
      deps: ['urlName']
      fn: () -> "/admin/users/#{@.id}/edit"