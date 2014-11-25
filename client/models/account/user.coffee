User = require '../user.coffee'

module.exports = User.extend

  typeAttribute: 'accountUserModel'
  urlRoot: () -> return "/api/#{@accountUrl}/users"

  session:
    accountUrl: {type: 'string', required: yes}