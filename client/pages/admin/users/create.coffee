State = require 'ampersand-state'

PageView = require '../../base.coffee'
templates = require '../../../templates'
UserForm = require '../../../forms/user.coffee'

User = require '../../../models/admin/user.coffee'

NewPassword = State.extend
  props:
    name: 'string'
    email: 'string'
    password: 'string'


module.exports = PageView.extend

  pageTitle: 'Users Administration'
  template: templates.pages.admin.users.create

  events:
    'click [data-hook="cancel"]': 'cancel'

  cancel: () ->
    app.navigate('admin/users')

  subviews:
    form:
      container: 'form'
      prepareView: (el) ->
        return new UserForm
          el: el
          submitCallback: (data) ->
            newUser = new User(data)
            newUser.save data,
              success: (user, response, options) ->
                state = new NewPassword(response.tempPassword)
                app.router.adminUserPassword(state)
