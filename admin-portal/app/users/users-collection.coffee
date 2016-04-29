Collection = require 'ampersand-rest-collection'
UserModel = require './user-model.coffee'


module.exports = Collection.extend

  model: UserModel

  refresh: () ->
    options =
      url: App.baseUrl + "/data/_users/_all_docs?include_docs=true"
      method: "GET"
      dataType: 'json'

    $.ajax(options)
      .fail (data) ->
        log.debug {data: data}, "Response for failed request for users"
        log.error "Unexpected Error Getting Users"
        #TODO redirect to error page

      .done (data) =>
        users = _.map(data.rows,((row) -> row.doc))
        users = _.filter(users, ((user) -> user.type is 'user'))

        #filter out non openabr (if they exist)
        users = _.filter(users, ((user) -> user.userType? and user.userType is 'openabr'))

        @.reset(users)
