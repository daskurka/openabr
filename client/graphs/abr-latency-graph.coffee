d3 = require 'd3'
_ = require 'lodash'

MonotonicCubicSpline = require '../utils/monotonic-cubic-spline.coffee'

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

class AbrLatencyAnalyser

  constructor: (@rawValues, @containerWidth, @containerHeight, @margin) ->

    #calculate sizes
    @width = @containerWidth - @margin.left - @margin.right
    @height = @containerHeight - @margin.top - @margin.bottom

    #sort out data
    timeValues = []
    amplitudeValues = []
    @dataPoints = rawValues.map (value, index) ->
      time = index * sampleRate
      timeValues.push time
      amplitudeValues.push value
      return {time: index * sampleRate, amplitude: value}

    #prepare custom interpolator
    @interpolator = new MonotonicCubicSpline(timeValues, amplitudeValues)

  render: (graphEl, sampleRate, setMaxVoltage, setMinVoltage, peakData) ->

    #get some stats from the data
    sampleCount = @rawValues.length
    duration = sampleCount * sampleRate
    maxVoltage = _.max(rawValues)
    minVoltage = _.min(rawValues)

    x = d3.scale.linear().range([0, width])
    y = d3.scale.linear().range([height, 0])

    xAxis = d3.svg.axis().tickFormat(timeFormatter).scale(x).orient('bottom')
    yAxis = d3.svg.axis().tickFormat(voltageFormatter).scale(y).orient('left')

    x.domain([0, duration])
    y.domain([setMinVoltage * 1.2, setMaxVoltage * 1.2])

    line = d3.svg.line().interpolate('monotone')
      .x((d) -> x(d.time))
      .y((d) -> y(d.amplitude))

    svg = d3.select(graphEl)
      .append('svg')
      .attr('id','svgGraph')
      .attr('width', containerWidth)
      .attr('height', containerHeight)
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
      .text('Time (ms)')

    svg.append('g')
      .attr('class', 'y axis')
      .call(yAxis)
      .append('text')
      .attr('class', 'axisText')
      .attr('transform', 'rotate(-90)')
      .attr('y', 6)
      .attr('dy','.71em')
      .style('text-anchor', 'end')
      .text('Ampl. (µV)')

    svg.append('g')
      .attr('class','abr')
      .append('path')
      .datum(dataPoints)
      .attr('class','line')
      .attr('d', line)

    #ticks for both axis when selecting
    xAxisTick = svg.append('g')
      .attr('transform','translate(0,0)')
      .attr('id','xAxisTick')
      .style('opacity',0)

    xAxisTick.append('line')
      .attr('class','tick')
      .attr('x2',0)
      .attr('y2',6)

    xAxisTick.append('text')
      .attr('id','xAxisTickText')
      .attr('x',0)
      .attr('y',9)
      .attr('dy','.32em')
      .style('text-anchor', 'middle')
      .text('#.##')

    yAxisTick = svg.append('g')
      .attr('transform','translate(0,0)')
      .attr('id','yAxisTick')
      .style('opacity',0)

    yAxisTick.append('line')
      .attr('class','tick')
      .attr('x2',-6)
      .attr('y2',0)

    yAxisTick.append('text')
      .attr('id','yAxisTickText')
      .attr('x',-9)
      .attr('y',0)
      .attr('dy','.32em')
      .style('text-anchor', 'end')
      .text('#.##')

    #circle for cursor points
    svg.append('circle')
      .style('fill','green')
      .style('opacity',0)
      .attr('id','cursorCircle')
      .attr('cy',0)
      .attr('cx',0)
      .attr('r',3)

    #circles for each peak
    circleGroup = svg.selectAll('peakCursors')
      .data(peakData)
      .enter()
      .append('g')
      .attr('class','peakCursors')
      .attr('id', (d) -> return d.circleId)
      .style('opacity',0)
    circleGroup.append('circle')
      .style('fill','black')
      .attr('cy',0)
      .attr('cx',0)
      .attr('r',2)
    circleGroup.append('text')
      .attr('x', 10)
      .attr('y',(d) -> if d.type is 'peak' then -10 else 10)
      .attr('dy','.42em')
      .attr('class', (d) -> if d.type is 'peak' then 'peakText' else 'troughText')
      .text((d) -> return d.label)

    #invisiable rectangle for pointer events
    svg.append('svg:rect')
      .attr('width', width)
      .attr('height', height)
      .attr('fill', 'none')
      .attr('pointer-events', 'all')
      .on('mousemove', mouseMoveGraph)
      .on('mouseout', mouseOutGraph)
      .on('mouseenter', mouseEnterGraph)
      .on('click', mouseLeftClickGraph)
      .on('contextmenu', mouseRightClickGraph)

    #time to draw the latency boxes
    #some need calculations
    bigBoxesCount = 5
    smallBoxesCount = 3

    headerGroupMarginLeft = -25
    headerGroupMarginTop = height + margin.top + 10
    secondHeaderRowTopMargin = 15

    boxesMargin = 15
    boxesTop = headerGroupMarginTop + boxesMargin
    boxesLeft = boxesMargin
    boxesWidth = containerWidth - (boxesMargin*2)

    boxTargetWidth = 120

    bigBoxWidth = (boxesWidth - (boxesMargin*(bigBoxesCount-2))) / bigBoxesCount

    #only draw if there is room
    if bigBoxWidth > boxTargetWidth

      smallBoxWidth = bigBoxWidth / 3
      boxLeft = (big, small) -> boxesLeft + (big * bigBoxWidth) + (small * smallBoxWidth)

      romanLabels = [{l:'I',n:0},{l:'II',n:1},{l:'III',n:2},{l:'IV',n:3},{l:'V',n:4}]
      innerLabels = [{l:'+',n:0},{l:'-',n:1},{l:'Δ',n:2}]

      topHeaderGroup = svg.append('g')
      .attr('transform', "translate(#{0},#{headerGroupMarginTop})")
      innerHeaderGroup = topHeaderGroup.selectAll('romanHeader')
      .data(romanLabels)
      .enter()
      .append('g')
      .attr('transform', (d) -> return "translate(#{boxLeft(d.n,0)},0)")
      innerHeaderGroup.append('text')
      .attr('class','boxPeakNumber')
      .attr('x',10)
      .attr('y',20)
      .text((d) -> return d.l)
      reallyInnerHeaderGroup = innerHeaderGroup.selectAll('signHeader')
      .data((d) ->
        results = []
        for inner in innerLabels
          results.push {big: d.n, small: inner.n, label: inner.l}
        return results
      )
      .enter()
      .append('g')
      .attr('transform', (d) -> return "translate(#{boxLeft(d.big, d.small)-d.big*bigBoxWidth},#{secondHeaderRowTopMargin})")
      reallyInnerHeaderGroup.append('text')
      .attr('x',0)
      .attr('y',20)
      .text((d) -> return d.label)

      leftHeaderGroup = @svg.append('g')
      .attr('transform', "translate(#{headerGroupMarginLeft},#{boxesTop})")
      leftHeaderGroup.append('text')
      .attr('class','boxPeakLabel')
      .attr('x',0)
      .attr('y',45)
      .text('µV')
      leftHeaderGroup.append('text')
      .attr('class','boxPeakLabel')
      .attr('x',0)
      .attr('y',75)
      .text('ms')

      allBoxes = peakData
      allBoxes.push {boxId: 'delta1', type: 'delta', number: 1, isMarked: no}
      allBoxes.push {boxId: 'delta2', type: 'delta', number: 2, isMarked: no}
      allBoxes.push {boxId: 'delta3', type: 'delta', number: 3, isMarked: no}
      allBoxes.push {boxId: 'delta4', type: 'delta', number: 4, isMarked: no}
      allBoxes.push {boxId: 'delta5', type: 'delta', number: 5, isMarked: no}

      boxesGroup = svg.selectAll('peakBoxes')
      .data(allBoxes)
      .enter()
      .append('g')
      .attr('class','peakBoxes')
      .attr('id', (d) -> return d.boxId)
      .attr('transform', (d) ->
        minor = switch d.type
          when 'delta' then 2
          when 'trough' then 1
          when 'peak' then 0
        adjustment = boxLeft((Math.abs(d.number)-1),minor)
        return "translate(#{adjustment},#{boxesTop})")
      boxesGroup.append('text')
      .attr('class','boxPeakValue amplitudeValue')
      .attr('x',10)
      .attr('y',45)
      .text((d) -> if d.isMarked then return d.amplitude else return '???')
      boxesGroup.append('text')
      .attr('class','boxPeakValue timeValue')
      .attr('x',10)
      .attr('y',75)
      .text((d) -> if d.isMarked then return d.time else return '???')