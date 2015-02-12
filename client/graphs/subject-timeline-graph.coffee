d3 = require 'd3'
_ = require 'lodash'

class SubjectTimelineGraph

  self = null

  #TODO correctly attribute this usage
  #<div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>         is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>
  pulsePath = 'M 11.667 24.084 c -0.557 0 -1.039 -0.248 -1.152 -0.794 l -1.561 -7.473 l -1.028 1.775 c -0.211 0.358 -0.597 0.613 -1.012 0.613 H 1.229 c -0.649 0 -1.176 -0.527 -1.176 -1.175 c 0 -0.649 0.527 -1.177 1.176 -1.177 h 5.013 l 2.235 -3.777 c 0.247 -0.417 0.721 -0.644 1.205 -0.562 c 0.479 0.08 0.86 0.446 0.958 0.921 l 0.945 4.567 L 13.74 5.046 c 0.101 -0.56 0.588 -0.949 1.158 -0.949 c 0.001 0 0.004 0 0.005 0 c 0.571 0 1.058 0.396 1.154 0.958 l 2.3 13.421 l 0.74 -1.875 c 0.176 -0.45 0.61 -0.749 1.093 -0.749 h 10.434 c 0.649 0 1.175 0.527 1.175 1.177 c 0 0.648 -0.526 1.175 -1.175 1.175 h -9.635 l -1.99 5.03 c -0.193 0.49 -0.682 0.787 -1.215 0.737 c -0.523 -0.055 -0.948 -0.452 -1.037 -0.971 l -1.877 -10.966 L 12.824 23.26 c -0.1 0.554 -0.579 0.824 -1.142 0.824 C 11.677 24.084 11.672 24.084 11.667 24.084 Z'

  constructor: (@graphEl, @parent, @maxDate, @minDate, @containerWidth, @containerHeight) ->
    self = @

  render: (events) ->

    margin = {top: 0, right: 20, bottom: 60, left: 20}

    width = @containerWidth - margin.left - margin.right
    height = @containerHeight - margin.top - margin.bottom

    #sort out weeks range
    minWeeks = 0
    diff = @.maxDate - @.minDate
    maxWeeks = Math.ceil(diff / 604800000)

    #hack for now, later should bind this correctly
    config =
      click:
        height: height / 3 + 10
        colour: 'salmon'
      tone:
        height: (height / 3)*2 + 10
        colour: 'lightblue'

    xDates = d3.time.scale().range([0, width])
    xDates.domain([@minDate, @maxDate])

    xWeeks = d3.scale.linear().range([0, width])
    xWeeks.domain([minWeeks, maxWeeks])

    xAxisDates = d3.svg.axis().scale(xDates).orient('bottom')
    xAxisWeeks = d3.svg.axis().scale(xWeeks).orient('bottom')

    @svg = d3.select(@graphEl)
      .append('svg')
        .attr('width', @containerWidth)
        .attr('height', @containerHeight)
      .append('g')
        .attr('transform',"translate(#{margin.left},#{margin.top})")

    @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform',"translate(0,#{height+40})")
      .call(xAxisDates)
      .append("text")
      .attr("x", width)
      .attr('y',-13)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Date")

    @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform',"translate(0,#{height})")
      .call(xAxisWeeks)
      .append("text")
      .attr("x", width)
      .attr('y',-13)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Weeks")

    @.svg.append('text')
      .attr('class','subject-event-title')
      .attr('id','event-title')
      .attr('opacity',0)
      .attr('x',() -> width/2)
      .attr('y',0)
      .attr('dy','16px')
      .text('loading...')

    circleContainer = @.svg.append('g')
      .attr('class', 'event-circles')

    circle = circleContainer.selectAll('.circle')
        .data(events)
      .enter().append('g')
        .attr('class','event-circle')
        .attr('data-id', (d) -> d.id)
        .attr('data-type', (d) -> d.type)
        .attr('data-name', (d) -> d.name)
        .attr('data-date', (d) -> d.date.toISOString().split('T')[0])
        .attr('data-week', (d) -> Math.ceil(xWeeks.invert(xDates(d.date))))
        .attr('transform', (d) => "translate(#{xDates(d.date)},#{config[d.type].height})")
        .on('mouseout', @mouseOutCircle)
        .on('mouseenter', @mouseEnterCircle)
        .on('click', @mouseLeftClickCircle)
        .on('contextmenu', @mouseRightClickCircle)

    circle.append('circle')
      .attr('r',18)
      .attr('fill',(d) => config[d.type].colour)

    circle.append('path')
      .attr('d', pulsePath)
      .attr('class','pulse-path-line')
      .attr('transform', 'translate(-15,-15)')
      .attr('pointer-events', 'none')

    @.svg.append('svg:rect')
      .attr('width', @width)
      .attr('height', @height)
      .attr('fill', 'none')
      .attr('pointer-events', 'all')


  getValues = (el) ->
    value =
      id: $(el)[0].attributes['data-id'].value
      type: $(el)[0].attributes['data-type'].value
      name: $(el)[0].attributes['data-name'].value
      date: $(el)[0].attributes['data-date'].value
      week: $(el)[0].attributes['data-week'].value
    return value

  mouseOutCircle: () ->
    $('#event-title',@.graphEl).attr('opacity',0)
    if self.parent? and self.parent.trigger?
      self.parent.trigger 'exit:group', getValues(@)

  mouseEnterCircle: () ->
    values = getValues(@)
    $('#event-title',@.graphEl).text("#{values.name} (#{values.date} - #{values.week} weeks)")
    $('#event-title',@.graphEl).attr('opacity',1)
    if self.parent? and self.parent.trigger?
      self.parent.trigger 'enter:group', values

  mouseLeftClickCircle: () ->
    if self.parent? and self.parent.trigger?
      self.parent.trigger 'left-click:group', getValues(@)

  mouseRightClickCircle: () ->
    if self.parent? and self.parent.trigger?
      self.parent.trigger 'right-click:group', getValues(@)
    d3.event.preventDefault() #this stops context menu

module.exports = SubjectTimelineGraph
