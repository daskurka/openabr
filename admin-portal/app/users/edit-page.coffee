BasePage = require '../base-page'
Template = require './edit-template.jade'

FormView = require 'ampersand-form-view'
InputView = require '../form/input-view'

DisplayPasswordPage = require './display-password-page'

module.exports = BasePage.extend

  template: Template

  props:
    allowSubmit: ['boolean',yes,no]

  bindings:
    'allowSubmit':
      hook: 'save'
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
          value: @.model.title,
          hint: 'This is a user friendly version of their name. It must be at least 3 characters long and all unicode characters are valid.'})
        new InputView({
          name: 'name',
          label: 'Email / Username',
          value: @.model.name,
          hint: 'Sorry this cannot be changed once set.',
          readonly: yes})
        new InputView({
          name: 'roles',
          label: 'Roles',
          value: @.model.roles.join(','),
          hint: 'Sorry this cannot be changed once set.',
          readonly: yes})
      ]

    @.form = new FormView(formConfig)
    @.registerSubview(@.form)

    return @

  events:
    'click [data-hook~=delete]': 'delete'
    'click [data-hook~=cancel]': 'cancel'
    'click [data-hook~=save]': 'save'
    'click [data-hook~=reset-password]': 'resetPassword'

  delete: () ->
    if confirm("Are you absolutely sure you want to delete the user '#{@.model.name}'\nThis will orphan any records they have ownership of and remove the user from the system permanantly.")
      options =
        url: App.baseUrl + "/data/_users/#{@.model._id}?rev=#{@.model._rev}"
        method: "DELETE"

      $.ajax(options)
        .fail (data, response) ->
          log.error "Unexpected error while trying to load model for for page."
          #TODO error page

        .done () ->
          alert("User has been deleted from the system successfully.")
          App.navigate '/users'


  cancel: () ->
    App.navigate '/users'


  save: () ->
    #validation done already
    newTitle = @.form.getValue('title')
    if @.model.title isnt newTitle
      @.model.title = newTitle
      @.model.save {},
        success: (model) =>
          App.navigate "/users"
        error: (model, response) ->
          log.error "Unexpected error while trying to load model for for page."
          #TODO Handle errors

  resetPassword: () ->
    #generate password
    #Inspirecd by http://stackoverflow.com/a/1349426
    charactersToGenerate = 6
    password = ""
    charactersToUse = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    for i in [0...charactersToGenerate]
      password += charactersToUse.charAt(Math.floor(Math.random() * charactersToUse.length))

    @.model.save {password},
      success: (model) =>
        #redirect to password page
        passwordPage = new DisplayPasswordPage({username: @.model.name, password: password})
        App.router.trigger 'page', passwordPage

      error: (model, response) ->
        log.error "Unexpected error while trying to load model for for page."
        #TODO Handle errors
