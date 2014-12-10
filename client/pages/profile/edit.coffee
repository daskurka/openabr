PageView = require '../base.coffee'
templates = require '../../templates'
UserForm = require '../../forms/user.coffee'

module.exports = PageView.extend

  pageTitle: 'Edit Profile'
  template: templates.pages.profile.edit

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
                app.navigate('/profile')