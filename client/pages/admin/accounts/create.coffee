PageView = require '../../base.coffee'
templates = require '../../../templates'
AccountForm = require '../../../forms/account.coffee'

Account = require '../../../models/admin/account.coffee'

module.exports = PageView.extend

  pageTitle: 'Accounts Administration'
  template: templates.pages.admin.accounts.create
  subviews:
    form:
      container: 'form'
      prepareView: (el) ->
        return new AccountForm
          el: el
          submitCallback: (data) ->
            newAccount = new Account(data)
            newAccount.suspended = no
            newAccount.suspendedNotice = ''
            newAccount.save()

            app.navigate('admin/accounts')