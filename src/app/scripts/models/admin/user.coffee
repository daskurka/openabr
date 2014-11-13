User = require '../user.coffee'

module.exports = User.extend

  typeAttribute: 'adminUserModel'
  urlRoot: '/api/admin/users'