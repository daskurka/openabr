exports.filterQuery = (params) ->

  #default
  query = params
  options = {}
  isPaged = no

  if params.pager?
    isPaged = yes

    query = params.query

    index = params.pager.pageIndex
    size = params.pager.pageSize

    if index <= 0 then index = 1

    options.limit = size
    options.skip = (index - 1) * size

  return {query, options, isPaged}

exports.attachResponseHeaders = (res, totalFound) ->

  res.header('Total-Records-Found', totalFound)
  res.header('Are-Results-Paged', yes)