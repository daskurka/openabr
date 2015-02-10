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

#success is self closing after 'timeout' time but include a 'dismiss' button for backup
showSuccessAlert = (title, message, timeout) ->
  buttonHtml = "<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>"
  messageHtml = "<strong>#{title}</strong> #{message}"
  $('#successAlert').html(buttonHtml + messageHtml).show()
  after timeout, () -> $('#successAlert').hide()

#info alert is closed by the program after some event has occured
showInfoAlert = (title, message) ->
  messageHtml = "<strong>#{title}</strong> #{message}"
  $('#infoAlert').html(messageHtml).show()

hideInfoAlert = () -> $('#infoAlert').hide()

#convert to human readable roman number :)
toRomanNumber = (peakNumber) ->
  switch peakNumber
    when 1 then 'I'
    when 2 then 'II'
    when 3 then 'III'
    when 4 then 'IV'
    when 5 then 'V'

class AbrLatencyAnalyser

  self = null

  constructor: (@rawValues, @sampleRate, @containerWidth, @containerHeight,
                @margin, @setMaxVoltage, @setMinVoltage, @parent) ->

    #calculate sizes
    @width = @containerWidth - @margin.left - @margin.right
    @height = @containerHeight - @margin.top - @margin.bottom

    #peak config
    @peakConfig = {
      peak1: {number: 1, circleId: 'pkCircle1', boxId: 'pkBox1', label: 'I', isMarked: no, type: 'peak', amplitude: null, time: null}
      peak2: {number: 2, circleId: 'pkCircle2', boxId: 'pkBox2', label: 'II', isMarked: no, type: 'peak', amplitude: null, time: null}
      peak3: {number: 3, circleId: 'pkCircle3', boxId: 'pkBox3', label: 'III', isMarked: no, type: 'peak', amplitude: null, time: null}
      peak4: {number: 4, circleId: 'pkCircle4', boxId: 'pkBox4', label: 'IV', isMarked: no, type: 'peak', amplitude: null, time: null}
      peak5: {number: 5, circleId: 'pkCircle5', boxId: 'pkBox5', label: 'V', isMarked: no, type: 'peak', amplitude: null, time: null}
      trough1: {number: -1, circleId: 'trCircle1', boxId: 'trBox1', label: '-I', isMarked: no, type: 'trough', amplitude: null, time: null}
      trough2: {number: -2, circleId: 'trCircle2', boxId: 'trBox2', label: '-II', isMarked: no, type: 'trough', amplitude: null, time: null}
      trough3: {number: -3, circleId: 'trCircle3', boxId: 'trBox3', label: '-III', isMarked: no, type: 'trough', amplitude: null, time: null}
      trough4: {number: -4, circleId: 'trCircle4', boxId: 'trBox4', label: '-IV', isMarked: no, type: 'trough', amplitude: null, time: null}
      trough5: {number: -5, circleId: 'trCircle5', boxId: 'trBox5', label: '-V', isMarked: no, type: 'trough', amplitude: null, time: null}
    }

    @peakDataArray = []
    for peak of @peakConfig
      @peakDataArray.push @peakConfig[peak]

    #get some stats from the data
    @sampleCount = @rawValues.length
    @duration = @sampleCount * @sampleRate
    @maxVoltage = _.max(@rawValues)
    @minVoltage = _.min(@rawValues)

    #sort out data
    timeValues = []
    amplitudeValues = []
    @dataPoints = @rawValues.map (value, index) =>
      time = index * @sampleRate
      timeValues.push time
      amplitudeValues.push value
      return {time: time, amplitude: value}

    #prepare custom interpolator
    @interpolator = new MonotonicCubicSpline(timeValues, amplitudeValues)

    #to be assigned on render
    @svg = null
    @x = null
    @y = null
    @graphEl

    #state machine modes
    @multiplePeaks = yes
    @currentPeak = 1
    @isPeak = yes
    @markPeakMode = no

    #hack because of d3
    self = @

    #were our results are stored
    @latency = {peaks: []}

  render: (graphEl) ->
    $(graphEl).html('')
    @.graphEl = graphEl

    @x = d3.scale.linear().range([0, @width])
    @y = d3.scale.linear().range([@height, 0])

    xAxis = d3.svg.axis().tickFormat(timeFormatter).scale(@x).orient('bottom')
    yAxis = d3.svg.axis().tickFormat(voltageFormatter).scale(@y).orient('left')

    @x.domain([0, @duration])
    @y.domain([@setMinVoltage * 1.2, @setMaxVoltage * 1.2])

    line = d3.svg.line().interpolate('monotone')
      .x((d) -> self.x(d.time))
      .y((d) -> self.y(d.amplitude))

    @svg = d3.select(graphEl)
      .append('svg')
      .attr('id','svgGraph')
      .attr('width', @containerWidth)
      .attr('height', @containerHeight)
      .append('g')
      .attr('transform',"translate(#{@margin.left},#{@margin.top})")

    @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0,#{@height})")
      .call(xAxis)
      .append('text')
      .attr('class', 'axisText')
      .attr('x', @width)
      .attr('y', -6)
      .style('text-anchor', 'end')
      .text('Time (ms)')

    @svg.append('g')
      .attr('class', 'y axis')
      .call(yAxis)
      .append('text')
      .attr('class', 'axisText')
      .attr('transform', 'rotate(-90)')
      .attr('y', 6)
      .attr('dy','.71em')
      .style('text-anchor', 'end')
      .text('Ampl. (µV)')

    @svg.append('g')
      .attr('class','abr')
      .append('path')
      .datum(@dataPoints)
      .attr('class','line')
      .attr('d', line)

    #ticks for both axis when selecting
    xAxisTick = @svg.append('g')
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

    yAxisTick = @svg.append('g')
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
    @svg.append('circle')
      .style('fill','green')
      .style('opacity',0)
      .attr('id','cursorCircle')
      .attr('cy',0)
      .attr('cx',0)
      .attr('r',3)

    #circles for each peak
    circleGroup = @svg.selectAll('peakCursors')
      .data(@peakDataArray)
      .enter()
      .append('g')
      .attr('class','peakCursors')
      .attr('id', (d) -> return d.circleId)
      .style('opacity', (d) -> if d.isMarked then 1 else 0)
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
    @svg.append('svg:rect')
      .attr('width', @width)
      .attr('height', @height)
      .attr('fill', 'none')
      .attr('pointer-events', 'all')
      .on('mousemove', @mouseMoveGraph)
      .on('mouseout', @mouseOutGraph)
      .on('mouseenter', @mouseEnterGraph)
      .on('click', @mouseLeftClickGraph)
      .on('contextmenu', @mouseRightClickGraph)

    #time to draw the latency boxes
    #some need calculations
    bigBoxesCount = 5
    smallBoxesCount = 3

    headerGroupMarginLeft = -25
    headerGroupMarginTop = @height + @margin.top + 10
    secondHeaderRowTopMargin = 15

    boxesMargin = 15
    boxesTop = headerGroupMarginTop + boxesMargin
    boxesLeft = boxesMargin
    boxesWidth = @containerWidth - (boxesMargin*2)

    boxTargetWidth = 120

    bigBoxWidth = (boxesWidth - (boxesMargin*(bigBoxesCount-2))) / bigBoxesCount

    #only draw if there is room
    if bigBoxWidth > boxTargetWidth

      smallBoxWidth = bigBoxWidth / 3
      boxLeft = (big, small) -> boxesLeft + (big * bigBoxWidth) + (small * smallBoxWidth)

      romanLabels = [{l:'I',n:0},{l:'II',n:1},{l:'III',n:2},{l:'IV',n:3},{l:'V',n:4}]
      innerLabels = [{l:'+',n:0},{l:'-',n:1},{l:'Δ',n:2}]

      topHeaderGroup = @svg.append('g')
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

      allBoxes = @peakDataArray
      allBoxes.push {boxId: 'delta1', type: 'delta', number: 1, isMarked: no}
      allBoxes.push {boxId: 'delta2', type: 'delta', number: 2, isMarked: no}
      allBoxes.push {boxId: 'delta3', type: 'delta', number: 3, isMarked: no}
      allBoxes.push {boxId: 'delta4', type: 'delta', number: 4, isMarked: no}
      allBoxes.push {boxId: 'delta5', type: 'delta', number: 5, isMarked: no}

      boxesGroup = @svg.selectAll('peakBoxes')
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

  getCurrentPeakId: () -> return if self.isPeak then "peak#{self.currentPeak}" else "trough#{self.currentPeak}"
  getNextPeakId: () -> return if self.isPeak then "trough#{self.currentPeak+1}" else "peak#{self.currentPeak+1}"

  mouseMoveGraph: () ->
    [x,y] = d3.mouse(this)

    #cursor is locked to the mouse in the x-axis (time)
    #but follows the graph values for y-axis (amplitude)

    rawTime = self.x.invert(x)
    time = timeFormatter(rawTime)
    $('#xAxisTickText', @graphEl).text(time)
    $('#xAxisTick', @graphEl).attr('transform',"translate(#{x},#{self.height + 6})")

    rawVoltage = self.interpolator.interpolate(rawTime)
    voltagePosition = self.y(rawVoltage)

    voltage = voltageFormatter(rawVoltage)
    $('#yAxisTickText', @graphEl).text(voltage)
    $('#yAxisTick', @graphEl).attr('transform',"translate(0,#{voltagePosition})")

    if self.markPeakMode
      peak = self.peakConfig[self.getCurrentPeakId()]
      self.showPeak(peak.circleId, peak.boxId, rawVoltage, rawTime, x, voltagePosition)
    else
      $('#cursorCircle', @graphEl).attr('cx',x)
      $('#cursorCircle', @graphEl).attr('cy',voltagePosition)

  mouseOutGraph: () ->
    $('.x.axis g', @graphEl).css('opacity',1)
    $('.y.axis g', @graphEl).css('opacity',1)
    $('#xAxisTick', @graphEl).css('opacity',0)
    $('#yAxisTick', @graphEl).css('opacity',0)

    if self.markPeakMode
      peak = self.peakConfig[self.getCurrentPeakId()]
      if not peak.isMarked then self.hidePeak(peak.circleId, peak.boxId)
    else
      $('#cursorCircle').css('opacity',0)

  mouseEnterGraph: () ->
    $('.x.axis g', @graphEl).css('opacity',0.2)
    $('.y.axis g', @graphEl).css('opacity',0.2)
    $('#xAxisTick', @graphEl).css('opacity',1)
    $('#yAxisTick', @graphEl).css('opacity',1)

    if not self.markPeakMode
      $('#cursorCircle', @graphEl).css('opacity',1)

  mouseLeftClickGraph: () ->
    [x,y] = d3.mouse(this)

    #if not in mode then this should for now do nothing
    if not self.markPeakMode
      return

    #build set peak data
    {rawTime, rawVoltage} = self.mouseToValues(x,y)

    self.recordPeak(self.getCurrentPeakId(), rawTime, rawVoltage)

    #two modes of operation,
    #for single peak we cancel, for mulitple we move to next
    if self.multiplePeaks
      self.moveToNextPeak(x,y)
    else
      #if we are single peak but still technical on the 'peak' and not the trough we must continue
      if self.isPeak
        self.moveToNextPeak(x,y)
      else
        #todo: refresh everything?

        #and come out of peak mode as we are done
        self.markPeakMode = no

        #hide info alert
        do hideInfoAlert

  mouseRightClickGraph: () ->
    [x,y] = d3.mouse(this)

    #if not in mode then this should act normally
    if not self.markPeakMode
      return

    #undo current peak
    self.clearPeak(self.getCurrentPeakId())

    #for single peak we end and for mulitple we move to next
    if self.multiplePeaks
      self.moveToNextPeak(x,y)
    else
      #todo: cancel current peak?

      #come out of peak mode we are done
      self.markPeakMode = no

      #hide info alert
      do hideInfoAlert

    d3.event.preventDefault() #this stops context menu

  mouseToValues: (x,y) ->
    rawTime = self.x.invert(x)
    time = timeFormatter(rawTime)
    rawVoltage = self.interpolator.interpolate(rawTime)
    voltage = voltageFormatter(rawVoltage)
    realY = self.y(self.interpolator.interpolate(rawTime))

    return { rawTime, time, rawVoltage, voltage, x, y: realY }

  showPeak: (circleId, boxId, amplitude, time, positionX, positionY) ->
    #make visable and show at correct coordinates
    circleSelector = "##{circleId}"
    $(circleSelector, @graphEl).css('opacity',1)
    $(circleSelector, @graphEl).attr('transform',"translate(#{positionX},#{positionY})")

    #show voltage and time in correct format
    voltage = voltageFormatter(amplitude)
    latency = timeFormatter(time)
    boxSelector = "##{boxId}"
    $("#{boxSelector} .amplitudeValue", @graphEl).text(voltage)
    $("#{boxSelector} .timeValue", @graphEl).text(latency)

  hidePeak: (circleId, boxId) ->
    #just make the peak invisable
    $("##{circleId}", @graphEl).css('opacity',0)
    $("##{boxId} .amplitudeValue", @graphEl).text('???')
    $("##{boxId} .timeValue", @graphEl).text('???')

  hideDelta: (peak) ->
    $("#delta#{peak} .amplitudeValue", @graphEl).text('???')
    $("#delta#{peak} .timeValue", @graphEl).text('???')

  calculateDelta: (peak) ->
    amplPositive = self.peakConfig["peak#{peak}"].amplitude
    timePositive = self.peakConfig["peak#{peak}"].time
    amplNegative = self.peakConfig["trough#{peak}"].amplitude
    timeNegative = self.peakConfig["trough#{peak}"].time

    amplDelta = if amplNegative > 0 then amplNegative - amplPositive else Math.abs(amplNegative) + amplPositive
    timeDelta = timeNegative - timePositive

    $("#delta#{peak} .amplitudeValue").text(voltageFormatter(amplDelta))
    $("#delta#{peak} .timeValue").text(timeFormatter(timeDelta))

  moveToNextPeak: (x,y) ->
    #get mouse values for updating last positions
    mouseValues = self.mouseToValues(x,y)

    if self.currentPeak is 5 and not self.isPeak
      #all done, exiting
      #come out of peak mode we are done
      self.markPeakMode = no

      #hide last peak if not marked
      peak = self.peakConfig[self.getCurrentPeakId()]
      if not peak.isMarked
        self.hidePeak(peak.circleId, peak.boxId)
      else
        positionX = self.x(peak.time)
        positionY = self.y(peak.amplitude)
        self.showPeak(peak.circleId, peak.boxId, peak.amplitude, peak.time, positionX, positionY)

      #hide info alert
      do hideInfoAlert

      #show cursor
      $('#cursorCircle', @graphEl).css('opacity',1)
      $('#cursorCircle', @graphEl).attr('cx',mouseValues.x)
      $('#cursorCircle', @graphEl).attr('cy',mouseValues.y)

    else if self.isPeak
      peak = self.peakConfig[self.getCurrentPeakId()]
      if not peak.isMarked
        self.hidePeak(peak.circleId, peak.boxId)
      else
        positionX = self.x(peak.time)
        positionY = self.y(peak.amplitude)
        self.showPeak(peak.circleId, peak.boxId, peak.amplitude, peak.time, positionX, positionY)

      #trough comes next - same number
      self.isPeak = no

      peak = self.peakConfig[self.getCurrentPeakId()]
      positionX = self.x(peak.time)
      positionY = self.y(peak.amplitude)
      self.showPeak(peak.circleId, peak.boxId, peak.amplitude, peak.time, positionX, positionY)

    else
      peak = self.peakConfig[self.getCurrentPeakId()]
      if not peak.isMarked
        self.hidePeak(peak.circleId, peak.boxId)
      else
        positionX = self.x(peak.time)
        positionY = self.y(peak.amplitude)
        self.showPeak(peak.circleId, peak.boxId, peak.amplitude, peak.time, positionX, positionY)

      #peak next and incremenet count
      self.isPeak = yes
      self.currentPeak++

      peak = self.peakConfig[self.getCurrentPeakId()]
      positionX = self.x(peak.time)
      positionY = self.y(peak.amplitude)
      self.showPeak(peak.circleId, peak.boxId, peak.amplitude, peak.time, positionX, positionY)

  markPeaks: () ->
    #start from peak 1 and mark each one in sequence
    @multiplePeaks = yes
    @currentPeak = 1
    @markPeakMode = yes
    @isPeak = yes

    #show info alert
    showInfoAlert('Mark Peaks & Troughs', '<i>Left Click</i> to mark the peak/trough on the graph and move to next, <i>Right Click</i> to skip/remove the current peak/trough and move to next.')

  markPeak: (peakNumber) ->
    #start from specified peak and no sequence
    @multiplePeaks = no
    @currentPeak = peakNumber
    @markPeakMode = yes
    @isPeak = yes

    #convert to roman number
    romanNumber = toRomanNumber(peakNumber)

    #show info alert
    showInfoAlert("Mark Peak & Trough'#{romanNumber}' (#{peakNumber})", '<i>Left Click</i> to mark the peak then the trough on the graph, <i>Right Click</i> to remove the current peak/trough marking.')

  checkPartnerPeaks: (peakId) ->
    peak = self.peakConfig[peakId]

    partnerPeak = null
    if peak.type is 'peak'
      partnerPeak = self.peakConfig["trough#{peak.number}"]
    else
      partnerPeak = self.peakConfig["peak#{Math.abs(peak.number)}"]

    if partnerPeak.isMarked
      self.calculateDelta(Math.abs(peak.number))
    else
      self.hideDelta(Math.abs(peak.number))

  recordPeak: (peakId, time, amplitude) ->
    @.peakConfig[peakId].time = time
    @.peakConfig[peakId].amplitude = amplitude
    @.peakConfig[peakId].isMarked = yes

    #this shows the circle and the box
    positionX = self.x(time)
    positionY = self.y(amplitude)
    self.showPeak(@.peakConfig[peakId].circleId, @.peakConfig[peakId].boxId, amplitude, time, positionX, positionY)

    @.checkPartnerPeaks(peakId)

    @.parent.trigger 'change:peaks', @.peakConfig

  clearPeak: (peakId) ->
    @.peakConfig[peakId].time = null
    @.peakConfig[peakId].amplitude = null
    @.peakConfig[peakId].isMarked = no

    @.hidePeak(@.peakConfig[peakId].circleId, @.peakConfig[peakId].boxId)
    @.hideDelta(Math.abs(@.peakConfig[peakId].number))

    @.checkPartnerPeaks(peakId)

  setPeaks: (peakData) ->
    if peakData is null then return

    peaksToShow = []
    for peak in peakData
      peakId = "peak#{peak.number}"
      troughId = "trough#{peak.number}"
      if peak.peakAmpl?
        @.peakConfig[peakId].amplitude = peak.peakAmpl
        @.peakConfig[peakId].time = peak.peakTime
        @.peakConfig[peakId].isMarked = yes
        peaksToShow.push peakId
      if peak.troughAmpl?
        @.peakConfig[troughId].amplitude = peak.troughAmpl
        @.peakConfig[troughId].time = peak.troughTime
        @.peakConfig[troughId].isMarked = yes
        peaksToShow.push troughId

    for id in peaksToShow
      config = @.peakConfig[id]
      positionX = self.x(config.time)
      positionY = self.y(config.amplitude)
      @.showPeak(config.circleId, config.boxId, config.amplitude, config.time, positionX, positionY)

module.exports = AbrLatencyAnalyser