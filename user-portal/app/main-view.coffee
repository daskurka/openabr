View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'
dom = require 'ampersand-dom'
localLinks = require 'local-links'

MainViewTemplate = require './main-template.jade'

module.exports = View.extend

  template: MainViewTemplate
  autoRender: yes

  initialize: () ->
    @.listenTo App.router, 'page', @.handleNewPage

  events:
    'click a[href]': 'handleLinkClick'

  render: () ->
    @.renderWithTemplate(@)

    pageSwitchOptions =
      show: (newView, oldView) ->
        pageTitle = _.result(newView, 'pageTitle')
        if pageTitle
          document.title = "#{pageTitle} - OpenABR"
        else
          document.title = "OpenABR"
        document.scrollTop = 0
        dom.addClass(newView.el, 'active')
        App.currentPage = newView

    @.pageSwitcher = new ViewSwitcher(@.queryByHook('page-container'),pageSwitchOptions)

    return @

  handleNewPage: (view) ->
    @.pageSwitcher.set(view)
    @.updateActiveNav()

  handleLinkClick: (e) ->
    localPath = localLinks.pathname(e)

    if localPath
      e.preventDefault()
      App.navigate(localPath)

  updateActiveNav: () ->
    path = window.location.pathname.slice(1)

    @.queryAll('.nav a[href]:not(.dropdown-toggle)').forEach (aTag) ->
      aPath = aTag.pathname.slice(1)

      if (!aPath and !path) or (aPath and path.indexOf(aPath) is 0)
        dom.addClass(aTag.parentNode, 'active')
      else
        dom.removeClass(aTag.parentNode, 'active')
