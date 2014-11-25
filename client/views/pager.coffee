View = require 'ampersand-view'
templates = require '../templates'


module.exports = View.extend

  template: templates.includes.pager

  initialize: () ->
    @.model.collection.on 'page:loaded', @.displayPages, @

  render: () ->
    @.renderWithTemplate()

    @.query('#pager-control').style.display = 'none'

    return @

  events:
    'click .pagination-item': 'changePage'

  displayPages: (pager) ->

    if not pager.pageIndex? or not pager.pageSize? or not pager.totalCount?
      console.log "Page index or count missing from pagination information: can not display pager."
      return @.query('#pager-control').style.display = 'none'

    @.query('#pager-control').style.display = 'block'

    page = pager.pageIndex
    count = Math.floor(pager.totalCount / pager.pageSize)
    if count is 0 then count = 1

    goBack = page > 1
    goForward = page < count

    isSimple = @.model.isSimple

    if isSimple
      #todo render simple

    else
      maxWidth = @.model.maxWidth
      pageLinks = []

      if maxWidth > count
        for i in [1..count]
          pageLinks.push {page: i, active: i is page}
      else
          middle = Math.floor(maxWidth / 2)
          left = page - 1
          right = count - page
          if left > middle
            left = page - middle
          else
            left = 1
          fromMiddle = count - middle
          if right > fromMiddle
            right = fromMiddle
          else
            right = count
          for i in [left..right]
            pageLinks.push {page: i, active: i is page}

      addActive = (page) -> return "<li class='active pagination-item' page='#{page}'><span>#{page}</span></li>"
      addNormal = (page) -> return "<li class='pagination-item' page='#{page}'><span>#{page}</span></li>"
      addDisabledGlyp = (glyp) -> return "<li class='disabled'><span class='glyphicon glyphicon-#{glyp}'></span></li>"
      addEnabledGly = (glyp, page) -> return "<li class='pagination-item' page='#{page}'><span class='glyphicon glyphicon-#{glyp}'></span></li>"

      html = '<ul class="pagination">'
      html += if goBack then addEnabledGly('fast-backward' ,1) else addDisabledGlyp('fast-backward')
      html += if goBack then addEnabledGly('step-backward', page - 1) else addDisabledGlyp('step-backward')

      for pageLink in pageLinks
        html += if pageLink.active then addActive(pageLink.page) else addNormal(pageLink.page)

      html += if goForward then addEnabledGly('step-forward', page + 1) else addDisabledGlyp('step-forward')
      html += if goForward then addEnabledGly('fast-forward' ,count) else addDisabledGlyp('fast-forward')
      html += '</ul>'

      @.query('#pager-control').innerHTML = html

  changePage: (e) ->
    nextPageIndex = Number(e.target.parentNode.attributes['page'].value)
    @.model.collection.changePage nextPageIndex