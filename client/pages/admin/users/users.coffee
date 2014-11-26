PageView = require '../../base.coffee'
templates = require '../../../templates'
UserView = require '../../../views/items/user.coffee'
UsersCollection = require '../../../collections/admin/users.coffee'
State = require 'ampersand-state'
PagerView = require '../../../views/pager.coffee'
PagerState = require '../../../configurations/pager.coffee'


after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'User Administration'
  template: templates.pages.admin.users.users

  initialize: () ->
    @.collection = new UsersCollection()
    @.pager = new PagerView(model: new PagerState(collection: @.collection))

  events:
    'click #newUser': 'newUser'
    'keyup [data-hook~=filter]': 'filterUsers'

  render: () ->
    #render everything
    @.renderWithTemplate(@)
    @.renderCollection(@.collection, UserView, @.queryByHook('users-table'))
    @.renderSubview(@.pager, @.queryByHook('pagination-control'))

    after 500, () => @.filterUsers()
    return @

  newUser: () ->
    app.navigate('admin/users/create')

  filterUsers: () ->
    @.collection.query @.queryByHook('filter').value