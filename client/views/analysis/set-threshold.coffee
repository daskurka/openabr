View = require 'ampersand-view'
templates = require '../../templates'
CollectionView = require 'ampersand-collection-view'

calcBoegarts = require '../../utils/bogaerts-threshold-analysis.coffee'

AbrSetGraph = require '../../graphs/abr-set-graph.coffee'

module.exports = View.extend

  template: templates.views.analysis.setThreshold

  bindings:
    'model.nameHtml':
      type: 'innerHTML'
      hook: 'name'
    'buttonLabel':
      type: 'innerHTML'
      hook: 'use-automatic'

  props:
    levels: 'array'
    initialLevel: 'number'

  derived:
    bogaertsReading:
      deps: ['model.readings']
      fn: () -> return calcBoegarts(@.model.readings)
    bogaertsLevel:
      deps: ['bogaertsReading']
      fn: () -> if @.bogaertsReading is null then -1 else @.bogaertsReading.level
    buttonLabel:
      deps: ['bogaertsLevel']
      fn: () ->
        if @.bogaertsLevel < 0
          return "Use Bogaerts et al (2009) - <strong>No Response</strong>"
        else
          return "Use Bogaerts et al (2009) - <strong>#{@.bogaertsLevel} dB</strong>"

  events:
    'click [data-hook~=use-automatic]': 'setBogaertsAsThreshold'
    'click [data-hook~=clear]': 'clearThreshold'
    'click [data-hook~=no-response]': 'noResponse'
    'mouseout .level-item': 'hoverLevel'
    'mouseover .level-item': 'hoverLevel'
    'click .level-item': 'manualSelect'

  setBogaertsAsThreshold: () ->
    @.setThreshold(@.bogaertsLevel, true, 'Bogaerts et al (2009)')

  setThreshold: (level, auto, method) ->
    if not @.model.analysis? then @.model.analysis = {}
    analysis = @.model.analysis
    analysis.threshold = {level, auto, method}
    @.model.set('analysis',analysis)
    @.model.trigger('change:analysis')

  clearThreshold: () ->
    if not @.model.analysis? then @.model.analysis = {}
    delete @.model.analysis.threshold
    @.model.trigger('change:analysis')

  initialize: (spec) ->
    @.currentGroup = spec.currentGroup

    if @.model.analysis and @.model.analysis.threshold
      @.initialLevel = @.model.analysis.threshold.level
    @.levels = @.model.readings.map (reading) -> reading.level

  render: () ->
    @.renderWithTemplate()

    @.renderSelector()
    @.renderGraph()

    @.model.on 'change:analysis', () =>
      if @.model.analysis.threshold?
        level = @.model.analysis.threshold.level
        $('.level-item').removeClass('list-group-item-success') #if already existed
        $('.level-item[data="' + level + '"]').addClass('list-group-item-success')
        $("path[level]").attr('class','graph-line graph-line-opacity')
        $("path[level='#{level}']").attr('class','graph-line graph-line-green')
      else
        $('.level-item').removeClass('list-group-item-success')
        $("path[level]").attr('class','graph-line graph-line-grey')

    return @

  hoverLevel: (event) ->
    if event.type is 'mouseover'
      $("path.graph-line-grey[level]").attr('class','graph-line graph-line-opacity')
      if event.target.hasAttribute('data')
        level = event.target.attributes['data'].value
        $("path.graph-line-opacity[level='#{level}']").attr('class','graph-line graph-line-highlighted')
    else
      $("path.graph-line-highlighted[level]").attr('class','graph-line graph-line-grey')

  manualSelect: (event) ->
    level = event.target.attributes['data'].value
    @.setThreshold(level, no, 'Manual select by ' + app.lookup.user(app.me.user.id).name)

  noResponse: () ->
    @.setThreshold(-1, no, 'Manual select by ' + app.lookup.user(app.me.user.id).name)

  renderSelector: () ->
    html = ''
    for level in @.levels
      extraClass = ''
      if @initialLevel isnt null and @initialLevel is level then extraClass = ' list-group-item-success'
      html += "<a class='list-group-item level-item#{extraClass}' style='cursor: pointer; text-align: center; font-weight: bold; font-size: 16px;' data='#{level}'>#{level} dB</a>"

    levelsEl = @.queryByHook('levels')
    levelsEl.innerHTML = html

  renderGraph: () ->
    @.grapher = new AbrSetGraph(440, 597) #todo make this responsive
    graphEl = @.query('#abrSetGraph')
    @.grapher.drawGraph(graphEl, @.model.readings, @.currentGroup.maxAmpl, @.currentGroup.minAmpl, @.initialLevel)

  hoverLevelItem: (event) ->
    console.log event.type





