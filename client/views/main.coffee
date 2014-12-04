View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'
domify = require 'domify'
NavbarView = require './navbar.coffee'


templates = require '../templates'

module.exports = View.extend

  template: templates.body

  initialize: () ->
    @.listenTo app.router, 'page', @.handleNewPage

  events:
    'click a[href]': 'handleLinkClick'

  render: () ->
    document.head.appendChild(domify(templates.head()))

    @.renderWithTemplate({me: @.me})

    @.pageSwitcher = new ViewSwitcher(@.queryByHook('page-container'), {
      show: (newView, oldView) ->
        document.title = 'OpenABR' #TODO search new views for title tags
        document.scrollTop = 0

        #TODO maybe the class specifier here to let page know its active

        app.currentPage = newView
    })

    #lets show the navbar
    @.navbar = new NavbarView()
    @.renderSubview @.navbar, '.navbar-container'

    return @

  handleNewPage: (view) ->
    @.pageSwitcher.set(view)
    #maybe here manager the navbar

  #this intercepts all path changes (url) and funnels them to the router
  handleLinkClick: (e) ->
    aTag = e.target
    local = aTag.host is window.location.host

    if local and not e.ctrlKey and not e.shiftKey and not e.altKey and not e.metaKey
      do e.preventDefault
      app.navigate(aTag.pathname)