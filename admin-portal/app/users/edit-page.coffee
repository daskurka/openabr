BasePage = require '../base-page'
Template = require './edit-template.jade'

module.exports = BasePage.extend

  template: Template


  events:
    'click [data-hook~=delete]': 'delete'
    'click [data-hook~=cancel]': 'cancel'
    'click [data-hook~=save]': 'save'


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
    console.log 'save...'
