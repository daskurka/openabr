PageView = require '../../base.coffee'
State = require 'ampersand-state'
templates = require '../../../templates'
UserForm = require '../../../forms/user.coffee'
ConfirmView = require '../../../views/confirm.coffee'
ConfirmModel = require '../../../models/confirm.coffee'
User = require '../../../models/admin/user.coffee'

NewPassword = State.extend
  props:
    name: 'string'
    email: 'string'
    password: 'string'

module.exports = PageView.extend

  pageTitle: 'Users Administration'
  template: templates.pages.admin.users.edit

  events:
    'click [data-hook="cancel"]': 'cancel'

  cancel: () ->
    app.navigate('admin/users')

  initialize: (spec) ->
      temp = new User(id: spec.user)
      temp.fetch
        success: (model) =>
          @.model = model

  removeUser: () ->
    @.model.destroy
      success: app.navigate('admin/users')

  resetPassword: () ->
    url = '/api/admin/users/reset'
    data = {id: @.model.id}
    $.get(url, data).done (response) ->
      state = new NewPassword(response)
      app.router.adminUserPassword(state)

  subviews:
    deleteConfirm:
      hook: 'delete-confirm'
      waitFor: 'model'
      prepareView: (el) ->
        model = new ConfirmModel
          message: 'Delete this user?'
          button: 'Delete'
        return new ConfirmView
          el: el
          model: model
          action: () => @.removeUser()
    resetPasswordConfirm:
      hook: 'reset-password-confirm'
      waitFor: 'model'
      prepareView: (el) ->
        model = new ConfirmModel
          message: 'Reset this users password?'
          button: 'Reset'
        return new ConfirmView
          el: el
          model: model
          action: () => @.resetPassword()
    form:
      container: 'form'
      waitFor: 'model'
      prepareView: (el) ->
        model = @.model
        return new UserForm
          el: el
          model: @.model
          submitCallback: (data) ->
            model.save data,
              wait: yes
              success: () ->
                app.navigate('admin/users')