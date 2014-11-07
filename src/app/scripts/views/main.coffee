View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'

templates = require '../templates'

class MainView extends View

  template: templates.body

  initialize: () ->
    @.listenTo app.router, 'page', @.handleNewPage

  events:
    'click a[href]': 'handleLinkClick'

  render: () ->

    @.renderWithTemplate()

    @.pageSwitcher = new ViewSwitcher(@.queryByHook('page-container'), {
      show: (newView, oldView) ->
        document.title = 'OpenABR' #TODO search new views for title tags
        document.scrollTop = 0

        #TODO maybe the class specifier here to let page know its active

        app.currentPage = newView
    })

    return @

  handleLinkClick: () ->
    console.log 'link click hit'

  handleNewPage: (view) ->
    @.pageSwitcher.set(view)
    #maybe here manager the navbar

module.exports = MainView
