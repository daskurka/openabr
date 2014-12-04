State = require 'ampersand-state'

PageView = require '../../base.coffee'
templates = require '../../../templates'
UserNewForm = require '../../../forms/userNew.coffee'

User = require '../../../models/admin/user.coffee'

NewPassword = State.extend
  props: [
    name: 'string'
    email: 'string'
    password: 'string'
  ]

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

            console.log 'Create Hit'
            console.log data
            return

            newUser = new User(data)
            newUser.save()

            app.navigate('admin/users')