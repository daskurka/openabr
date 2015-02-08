d3 = require 'd3'
_ = require 'lodash'
math = require 'mathjs'

class AbrSetGraph

  constructor: (@containerHeight, @containerWidth) ->
    @svg = null

  #formatter
  numberFormat = d3.format(".2f")
  timeFormatter = (rawValue) ->
    value = rawValue / 1000
    return numberFormat(value)
  voltageFormatter = (rawValue) ->
    value = rawValue * 1000000
    return numberFormat(value)

  drawGraph: (graphEl, abrReadings, maxValue, minValue, initLevel) ->

    margin = {top: 30, right: 30, bottom: 30, left: 60}
    width = @.containerWidth - margin.left - margin.right
    height = @.containerHeight - margin.top - margin.bottom

    x = d3.scale.linear().range([0, width])
    y = d3.scale.linear().range([height, 0])

    xAxis = d3.svg.axis().tickFormat(timeFormatter).scale(x).orient('bottom')
    yAxis = d3.svg.axis().tickFormat(voltageFormatter).scale(y).orient('left')

    line = d3.svg.line()
      .interpolate('basis')
      .x((d) -> x(d.time))
      .y((d) -> y(d.amplitude))

    @svg = d3.select(graphEl)
      .append('svg')
      .attr('width', @.containerWidth)
      .attr('height', @.containerHeight)
      .style('background','white')
      .append('g')
      .attr('transform',"translate(#{margin.left},#{margin.top})")

    numberSamples = _.max(abrReadings.map((r) -> r.numberSamples))
    sampleRate = math.median(abrReadings.map((r) -> r.sampleRate))
    duration = sampleRate * numberSamples

    x.domain([0, duration])
    y.domain([minValue*1.2, maxValue*1.2]) #a little spacing

    data = abrReadings.map (reading) ->
      return {
        name: reading.level
        values: reading.values.map (d, index) ->
          return {time: index * sampleRate, amplitude: d}
      }

    pathClass = (name, init) ->
      if not init?
        return "graph-line graph-line-grey"
      else
        if name is init
          return "graph-line graph-line-green"
        else
          return "graph-line graph-line-opacity"

    @svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0,#{height})")
      .call(xAxis)
      .append("text")
      .attr('class','axisText')
      .attr("x",width)
      .attr("y", -6)
      .style("text-anchor", "end")
      .text("Time (ms)")

    @svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .append("text")
      .attr('class','axisText')
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Ampl.(µV)")

    abr = @svg.selectAll(".abr")
      .data(data)
      .enter().append("g")
      .attr("class", "abr")

    abr.append("path")
      .attr("class", (d) -> pathClass(d.name, initLevel))
      .attr("d", (d) -> line(d.values))
      .attr("level", (d) -> d.name)

module.exports = AbrSetGraph