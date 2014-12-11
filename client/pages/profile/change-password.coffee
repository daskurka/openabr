PageView = require '../base.coffee'
templates = require '../../templates'
ChangePasswordForm = require '../../forms/change-password.coffee'

module.exports = PageView.extend

  pageTitle: 'View Profile'
  template: templates.pages.profile.change

  events:
    'click [data-hook="cancel"]': 'cancel'

  cancel: () ->
    app.navigate('profile')

  subviews:
    form:
      container: 'form'
      waitFor: 'model'
      prepareView: (el) ->
        model = @.model
        return new ChangePasswordForm
          el: el
          submitCallback: (data) ->
            url = "/api/profile/#{model.id}/change-password"
            $.post(url, data).done () ->
              app.navigate('/profile')