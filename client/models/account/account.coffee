Account = require '../admin/account.coffee'

module.exports = Account.extend

  typeAttribute: 'accountModel'
  urlRoot: () -> return "/api/#{@urlName}"