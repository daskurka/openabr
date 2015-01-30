PageView = require '../base.coffee'
templates = require '../../templates'

SubjectModel = require '../../models/core/subject.coffee'

#PagerView = require '../../../views/pager.coffee'
#PagerState = require '../../../configurations/pager.coffee'


after = (ms, cb) -> setTimeout cb, ms

module.exports = PageView.extend

  pageTitle: 'Subjects'
  template: templates.pages.subjects.index

  initialize: () ->

    subject = new SubjectModel
      experiments: []
      creator: app.me.user.id
      reference: 'ABC1'
      strain: 'CBA'
      species: 'Mouse'
      dob: Date.now()
      fields:
        hello: 'there'
        there: 'hello'
        why: 1
        current: Date.now()

    #subject.save (stuff) ->
      #console.log stuff


    #@.collection = new UsersCollection()
    #@.pager = new PagerView(model: new PagerState(collection: @.collection))

  events:
    'click #newUser': 'newUser'
    'keyup [data-hook~=filter]': 'filterUsers'

  render: () ->
    #render everything
    @.renderWithTemplate(@)
    #@.renderCollection(@.collection, UserView, @.queryByHook('users-table'))
    #@.renderSubview(@.pager, @.queryByHook('pagination-control'))

    #after 500, () => @.filterUsers()
    #return @

  newUser: () ->
    app.navigate('admin/users/create')

  filterUsers: () ->
    @.collection.query @.queryByHook('filter').value