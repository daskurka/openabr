View = require 'ampersand-view'
templates = require '../../../templates'

AbrThresholdAnalysisGraph = require '../../../graphs/abr-threshold-analysis-graph.coffee'

module.exports = View.extend

  template: templates.views.graphs.threshold.graph

  session:
    graph: 'object'

  initialize: () ->
    @.graph = new AbrThresholdAnalysisGraph(@.model.graphWidth, @.model.graphHeight, @)

  render: () ->
    @.renderWithTemplate()

    @graphEl = @.queryByHook('threshold-analysis-graph')
    if @.model.mode is 'group'
      @.graph.renderSingleGroup(@graphEl, @.model.data)
    else
      switch @.model.groupBy
        when 'date-simple'
          @.graph.renderDateSimple(@graphEl, @.model.data.toneData, @.model.data.clickData, @.model.data.groups)