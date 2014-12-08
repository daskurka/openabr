PageView = require '../../base.coffee'
templates = require '../../../templates'
UserForm = require '../../../forms/user.coffee'

User = require '../../../models/admin/user.coffee'

module.exports = PageView.extend

  pageTitle: 'Users Administration'
  template: templates.pages.admin.users.edit

  initialize: (spec) ->
      temp = new User(id: spec.user)
      temp.fetch
        success: (model) =>
          @.model = model

  events:
    'click [data-hook=delete]': 'removeUser'

  removeUser: () ->
    @.model.destroy
      success: app.navigate('admin/users')

  subviews:
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