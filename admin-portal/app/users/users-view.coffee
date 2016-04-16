BasePage = require '../base-page'
Template = require './users-template.jade'

UserCollection = require './users-collection'
UserRowView = require './user-row-view'

module.exports = BasePage.extend

  template: Template
  autoRender: yes

  initialize: () ->
    @.collection = new UserCollection()

  events:
    'click #newUser': 'newUser'

  render: () ->
    @.renderWithTemplate(@)
    @.renderCollection(@.collection, UserRowView, @.queryByHook('users-table'))
    @.collection.refresh()
    return @

  newUser: () ->
    App.navigate('users/create')
