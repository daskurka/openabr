PageView = require '../../base.coffee'
templates = require '../../../templates'
AccountForm = require '../../../forms/account.coffee'

Account = require '../../../models/admin/account.coffee'

module.exports = PageView.extend

  pageTitle: 'Accounts Administration'
  template: templates.pages.admin.accounts.edit

  initialize: (spec) ->
    url = '/api/admin/accounts/lookup/' + spec.account
    $.get url, (raw) =>
      temp = new Account(raw)
      temp.fetch
        success: (model) =>
          @.model = model

  events:
    'click [data-hook=delete]': 'removeAccount'

  removeAccount: () ->
    @.model.destroy
      success: app.navigate('admin/accounts')

  subviews:
    form:
      container: 'form'
      waitFor: 'model'
      prepareView: (el) ->
        model = @.model
        return new AccountForm
          el: el
          model: @.model
          submitCallback: (data) ->
            model.save data,
              wait: yes
              success: () ->
                app.navigate('admin/accounts')