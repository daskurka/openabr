Base = require './base.coffee'

module.exports = Base.extend

  typeAttribute: 'pagedCollection'

  query: (query) ->
    @.fetch
      data: query
      success: (collection, response, options) ->
        collection.trigger 'query:loaded'

  queryPaged: (pageIndex, pageSize, data) ->

    data = {pager: {pageIndex, pageSize}, query: data}
    @.lastPagedQuery = data

    @.fetch
      data: data
      success: (collection, response, options) ->
        if options.xhr.headers['are-results-paged']? and options.xhr.headers['are-results-paged'] is 'true'

          #this is for any listening pagination views
          totalRecords = options.xhr.headers['total-records-found']
          collection.trigger 'page:loaded', {pageIndex, pageSize, totalCount: Number(totalRecords)}

  changePage: (pageIndex) ->

    data = @.lastPagedQuery
    if not data?
      return console.log 'Error! No previous query has been run on this collection.'

    @.queryPaged(pageIndex, data.pager.pageSize, data.query)
