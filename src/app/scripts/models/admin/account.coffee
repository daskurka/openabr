Base = require '../base.coffee'

module.exports = Base.extend

  typeAttribute: 'adminAccountModel'
  urlRoot: '/api/admin/accounts'

  props:
    name: 'string'
    urlName: 'string'
    address: 'string'
    contact: 'string'
    notes: 'string'
    suspended: { type: 'boolean', default: no, required: yes}
    suspendedNotice: 'string'
    users: { type: 'array', default: () -> []}
    admins: { type: 'array', default: () -> []}