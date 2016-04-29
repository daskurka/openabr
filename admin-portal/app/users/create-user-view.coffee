PageBase = require '../base-page'
Template = require './create-user-template.jade'

FormView = require 'ampersand-form-view'
InputView = require '../form/input-view'

DisplayPasswordPage = require './display-password-page'

module.exports = PageBase.extend

  pageTitle: "Create User"
  template: Template

  props:
    allowSubmit: 'boolean'

  bindings:
    'allowSubmit':
      hook: 'submit'
      type: 'booleanAttribute'
      name: 'disabled'
      invert: yes

  render: () ->
    @.renderWithTemplate(@)

    validTests = [
      (name) -> if name.length < 3 then return "Name must be at least 3 characters long."
    ]

    formConfig =
      autoRender: yes
      el: @.queryByHook('field-container')

      validCallback: (valid) =>
        @.allowSubmit = valid

      fields: [
        new InputView({
          name: 'title',
          label: 'Name / Title',
          tests: validTests,
          hint: 'This is a user friendly version of their name. It must be at least 3 characters long and all unicode characters are valid.'})
        new InputView({
          name: 'name',
          label: 'Email / Username',
          tests: validTests,
          hint: 'This is the login username. It must be unique and at least 3 characters. Email address and all unicode characters are valid.'})
        new InputView({
          name: 'roles',
          label: 'Roles',
          value: 'openabr-user',
          readonly: yes})
      ]

    @.form = new FormView(formConfig)
    @.registerSubview(@.form)

    return @

  events:
    'click [data-hook~=submit]': 'submit'
    'click [data-hook~=cancel]': 'cancel'

  submit: () ->
    #form must be valid if the submit button is enabled
    user = @.form.data
    user._id = "org.couchdb.user:" + @.form.data.name
    user.type = "user"
    user.userType = 'openabr'

    user.roles = user.roles.split(',')

    #generate password
    #Inspirecd by http://stackoverflow.com/a/1349426
    charactersToGenerate = 6
    password = ""
    charactersToUse = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    for i in [0...charactersToGenerate]
      password += charactersToUse.charAt(Math.floor(Math.random() * charactersToUse.length))

    user.password = password

    #create user
    options =
      url: App.baseUrl + "/data/_users/#{user._id}"
      method: "PUT"
      contentType: 'application/json'
      dataType: 'json'
      data: JSON.stringify(user)

    $.ajax(options)
      .fail (data) ->
        log.debug "Response for failed create user attempt"
        console.log data
        log.error "Unable to create user '#{user._id}'"
        #TODO redirect to error page


      .done (data) ->
        #redirect to password page
        passwordPage = new DisplayPasswordPage({username: user.name, password: user.password})
        App.router.trigger 'page', passwordPage


  cancel: () ->
    App.navigate '/users'
