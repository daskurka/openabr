State = require 'ampersand-state'

PageView = require '../../base.coffee'
templates = require '../../../templates'
UserNewForm = require '../../../forms/userNew.coffee'

User = require '../../../models/admin/user.coffee'

NewPassword = State.extend
  props:
    name: 'string'
    email: 'string'
    password: 'string'


module.exports = PageView.extend

  pageTitle: 'Users Administration'
  template: templates.pages.admin.users.create
  subviews:
    form:
      container: 'form'
      prepareView: (el) ->
        return new UserNewForm
          el: el
          submitCallback: (data) ->
            newUser = new User(data)
            newUser.save data,
              success: (user, response, options) ->
                state = new NewPassword(response.tempPassword)
                app.router.adminUserPassword(state)
