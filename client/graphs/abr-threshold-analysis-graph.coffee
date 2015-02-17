d3 = require 'd3'
_ = require 'lodash'

#formatters
numberFormat = d3.format(".2f")
timeFormatter = (rawValue) ->
  value = rawValue / 1000
  return numberFormat(value)
voltageFormatter = (rawValue) ->
  value = rawValue * 1000000
  return numberFormat(value)

#convert to human readable roman number :)
toRomanNumber = (peakNumber) ->
  switch peakNumber
    when 1 then 'I'
    when 2 then 'II'
    when 3 then 'III'
    when 4 then 'IV'
    when 5 then 'V'

class AbrThresholdAnalysisGraph

  constructor: (@containerWidth, @containerHeight, @parent) ->
    #ctor

  renderDateSimple: (graphEl, toneData, clickData, groups) ->
    $(graphEl).html('')

    margin = { top: 20, right: 20, bottom: 20, left: 160 }

    #calculate sizes
    width = @containerWidth - margin.left - margin.right
    height = @containerHeight - margin.top - margin.bottom

    columns = ['Click']
    lineData = []
    pointData = []

    #TODO: fix the cause of this (upload not saving date likely)
    groups = _.filter(groups, (g) -> return g isnt '1970-01-01')

    for group in groups
      #frequency part of the chart
      groupData = []
      if toneData[group]?
        for key of toneData[group]
          columnName = "#{parseInt(key) / 1000}"
          columns.push columnName
          groupData.push
            column: columnName
            level: toneData[group][key][0]
            name: group #for dots
        lineData.push
          name: group
          values: groupData

      #click part of the chart
      if clickData[group]?
        pointData.push
          column: 'Click'
          level: clickData[group][0]
          name: group

    columns = _.uniq(columns)

    x = d3.scale.ordinal()
      .rangePoints([0, width], 1)
      .domain(columns)

    y = d3.scale.linear()
      .range([height, 0])
      .domain([0,120])

    colour = d3.scale.category10()
    colour.domain(groups)

    splFormatter = (rawValue) -> if rawValue is 120 then return 'No Response' else rawValue
    xAxis = d3.svg.axis().scale(x).orient('bottom')
    yAxis = d3.svg.axis().tickFormat(splFormatter).scale(y).orient('left')

    line = d3.svg.line()
      .x((d) -> x(d.column))
      .y((d) -> y(d.level))

    svg = d3.select(graphEl)
      .append('svg')
      .attr('id','svgGraph')
      .attr('width', @containerWidth)
      .attr('height', @containerHeight)
      .append('g')
      .attr('transform',"translate(#{margin.left},#{margin.top})")

    svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0,#{height})")
      .call(xAxis)
      .append('text')
      .attr('class', 'axisText')
      .attr('x', width)
      .attr('y', -6)
      .style('text-anchor', 'end')
      .text('Frequency (kHz)')

    svg.append('g')
      .attr('class', 'y axis')
      .call(yAxis)
      .append('text')
      .attr('class', 'axisText')
      .attr('transform', 'rotate(-90)')
      .attr('y', 6)
      .attr('dy','.71em')
      .style('text-anchor', 'end')
      .text('Threshold (dB SPL)')

    tline = svg.selectAll(".threshold-line")
      .data(lineData)
      .enter().append("g")
      .attr("class", (d) -> "threshold-line threshold-feature group-#{d.name}")

    tline.append("path")
      .attr('class','line')
      .attr("d", (d) -> line(d.values))
      .style('stroke', (d) -> colour(d.name))

    for toneLine in lineData
      toneDot = svg.selectAll(".threshold-tone-dot.group-#{toneLine.name}")
        .data(toneLine.values)
        .enter().append('g')
        .attr('class', "threshold-tone-dot threshold-feature group-#{toneLine.name}")

      toneDot.append('circle')
        .attr('class','threshold-dot')
        .attr('r',3)
        .attr('cx', (d) -> x(d.column))
        .attr('cy', (d) -> y(d.level))
        .style('fill', (d) -> colour(d.name))

    pointDot = svg.selectAll('.threshold-click-dot')
      .data(pointData)
      .enter().append('g')
      .attr('class', (d) -> "threshold-click-dot threshold-feature group-#{d.name}")

    pointDot.append('circle')
      .attr('class', 'threshold-dot')
      .attr('r',3)
      .attr('cx', (d) -> x(d.column))
      .attr('cy', (d) -> y(d.level))
      .style('fill', (d) -> colour(d.name))

    legend = svg.selectAll('.legend')
      .data(colour.domain())
      .enter().append('g')
      .attr('class','legend')
      .attr('transform', (d,i) -> "translate(#{10 - margin.left},#{(i*30)+30})")
      .attr('data-group', (d) -> 'group-' + d)
      .on('mouseout', @mouseOutLegend)
      .on('mouseenter', @mouseEnterLegend)

    legend.append('rect')
      .attr('x', 0)
      .attr('width', 18)
      .attr('height', 18)
      .style('fill', colour)

    legend.append('text')
      .attr('x', 24)
      .attr('y', 9)
      .attr('dy', '.35em')
      .style('text-anchor','start')
      .text((d) -> d)

  renderSingleGroup: (graphEl, values) ->
    $(graphEl).html('')

    margin = { top: 20, right: 20, bottom: 20, left: 100 }

    #calculate sizes
    width = @containerWidth - margin.left - margin.right
    height = @containerHeight - margin.top - margin.bottom

    #values - freq, level

    columns = []
    clickLevel = null
    toneLevels = []
    for value in values
      if value.freq?
        columnName = "#{parseInt(value.freq) / 1000}"
        columns.push columnName
        toneLevels.push
          level: value.level
          column: columnName
      else
        clickLevel = value.level #no freq, then must be a click
        columns.push 'Click'

    x = d3.scale.ordinal()
      .rangePoints([0, width], 1)
      .domain(columns)

    y = d3.scale.linear()
      .range([height, 0])
      .domain([0,120])

    splFormatter = (rawValue) -> if rawValue is 120 then return 'No Response' else rawValue
    xAxis = d3.svg.axis().scale(x).orient('bottom')
    yAxis = d3.svg.axis().tickFormat(splFormatter).scale(y).orient('left')

    line = d3.svg.line()
      .x((d) -> x(d.column))
      .y((d) -> y(d.level))

    svg = d3.select(graphEl)
      .append('svg')
      .attr('id','svgGraph')
      .attr('width', @containerWidth)
      .attr('height', @containerHeight)
      .append('g')
      .attr('transform',"translate(#{margin.left},#{margin.top})")

    xAxisG = svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0,#{height})")
      .call(xAxis)

    if toneLevels.length > 0
      xAxisG.append('text')
        .attr('class', 'axisText')
        .attr('x', width)
        .attr('y', -6)
        .style('text-anchor', 'end')
        .text('Frequency (kHz)')

    svg.append('g')
      .attr('class', 'y axis')
      .call(yAxis)
      .append('text')
      .attr('class', 'axisText')
      .attr('transform', 'rotate(-90)')
      .attr('y', 6)
      .attr('dy','.71em')
      .style('text-anchor', 'end')
      .text('Threshold (dB SPL)')

    svg.append("path")
      .datum(toneLevels)
      .attr('class','line')
      .attr("d", line)
      .style('stroke', 'red')

    toneDot = svg.selectAll(".threshold-tone-dot")
      .data(toneLevels)
      .enter().append('g')
      .attr('class', "threshold-tone-dot")

    toneDot.append('circle')
      .attr('class','threshold-dot')
      .attr('r',3)
      .attr('cx', (d) -> x(d.column))
      .attr('cy', (d) -> y(d.level))
      .style('fill', 'red')

    if clickLevel?
      svg.append('circle')
        .attr('class', 'threshold-dot')
        .attr('r',3)
        .attr('cx', () -> x('Click'))
        .attr('cy', () -> y(clickLevel))
        .style('fill', 'red')

  mouseOutLegend: () ->
    d3.selectAll('.threshold-feature').style('opacity',1)

  mouseEnterLegend: () ->
    groupSelector = ".#{d3.select(@).attr('data-group')}"
    d3.selectAll('.threshold-feature').style('opacity',0.3)
    d3.selectAll(groupSelector).style('opacity',1)


module.exports = AbrThresholdAnalysisGraph