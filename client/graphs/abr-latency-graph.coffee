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
                @margin, @setMaxVoltage, @setMinVoltage, @peakConfig, @parent) ->

    #calculate sizes
    @width = @containerWidth - @margin.left - @margin.right
    @height = @containerHeight - @margin.top - @margin.bottom

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

    #state machine modes
    @multiplePeaks = yes
    @currentPeak = 1
    @markPeakMode = no

    #hack because of d3
    self = @

    #were our results are stored
    @latency = {peaks: []}

  render: (graphEl) ->

    $(graphEl).html('')

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
      .data(@peakConfig)
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

      allBoxes = @peakConfig
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

  mouseMoveGraph: () ->
    [x,y] = d3.mouse(this)

    #cursor is locked to the mouse in the x-axis (time)
    #but follows the graph values for y-axis (amplitude)

    rawTime = self.x.invert(x)
    time = timeFormatter(rawTime)
    $('#xAxisTickText').text(time)
    $('#xAxisTick').attr('transform',"translate(#{x},#{self.height + 6})")

    rawVoltage = self.interpolator.interpolate(rawTime)
    voltagePosition = self.y(rawVoltage)

    voltage = voltageFormatter(rawVoltage)
    $('#yAxisTickText').text(voltage)
    $('#yAxisTick').attr('transform',"translate(0,#{voltagePosition})")

    if self.markPeakMode
      peak = self.peakConfig[self.currentPeak-1]
      self.showPeak(peak.circleId, peak.boxId, rawVoltage, rawTime, x, voltagePosition)
    else
      $('#cursorCircle').attr('cx',x)
      $('#cursorCircle').attr('cy',voltagePosition)

  mouseOutGraph: () ->
    $('.x.axis g').css('opacity',1)
    $('.y.axis g').css('opacity',1)
    $('#xAxisTick').css('opacity',0)
    $('#yAxisTick').css('opacity',0)

    if self.markPeakMode
      peak = self.peakConfig[self.currentPeak-1]
      if not peak.isMarked then self.hidePeak(peak.id)
    else
      $('#cursorCircle').css('opacity',0)

  mouseEnterGraph: () ->
    $('.x.axis g').css('opacity',0.2)
    $('.y.axis g').css('opacity',0.2)
    $('#xAxisTick').css('opacity',1)
    $('#yAxisTick').css('opacity',1)

    if self.markPeakMode
      peak = self.peakConfig[self.currentPeak-1]
      $("##{peak.id}").css('opacity',1)
    else
      $('#cursorCircle').css('opacity',1)

  mouseLeftClickGraph: () ->
    [x,y] = d3.mouse(this)

    #if not in mode then this should for now do nothing
    if not self.markPeakMode
      return

    #build set peak data
    {rawTime, rawVoltage} = self.mouseToValues(x,y)

    self.recordPeak(self.peakConfig[self.currentPeak-1].number, rawTime, rawVoltage)

    #two modes of operation,
    #for single peak we cancel, for mulitple we move to next
    if self.multiplePeaks
      self.moveToNextPeak(x,y)
    else
      #if we are single peak but still on positive number then move to negative number
      if self.currentPeak <= 5
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
    self.clearPeak(self.peakConfig[self.currentPeak-1].number)

    #for single peak we end and for mulitple we move to next
    if self.multiplePeaks
      self.moveToNextPeak(x,y)
    else
      #todo: cancel current peak

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
    $("##{circleId}").css('opacity',1)
    $("##{circleId}").attr('transform',"translate(#{positionX},#{positionY})")

    #show voltage and time in correct format
    voltage = voltageFormatter(amplitude)
    latency = timeFormatter(time)
    $("##{boxId} .amplitudeValue").text(voltage)
    $("##{boxId} .timeValue").text(latency)

  hidePeak: (circleId, boxId) ->
    #just make the peak invisable
    $("##{circleId}").css('opacity',0)
    $("##{boxId} .amplitudeValue").text('???')
    $("##{boxId} .timeValue").text('???')

  hideDelta: (peak) ->
    $("#delta#{peak} .amplitudeValue").text('???')
    $("#delta#{peak} .timeValue").text('???')

  calculateDelta: (peak) ->
    amplPositive = self.peakConfig[peak-1].amplitude
    timePositive = self.peakConfig[peak-1].time
    amplNegative = self.peakConfig[peak+4].amplitude
    timeNegative = self.peakConfig[peak+4].time

    amplDelta = if amplNegative > 0 then amplNegative - amplPositive else Math.abs(amplNegative) + amplPositive
    timeDelta = timeNegative - timePositive

    $("#delta#{peak} .amplitudeValue").text(voltageFormatter(amplDelta))
    $("#delta#{peak} .timeValue").text(timeFormatter(timeDelta))

  moveToNextPeak: (x,y) ->
    #get mouse values for updating last positions
    mouseValues = self.mouseToValues(x,y)

    if self.currentPeak isnt 10
      #hide and reposition current peak
      oldPeak = self.peakConfig[self.currentPeak-1]
      if not oldPeak.isMarked
        self.hidePeak(oldPeak.circleId, oldPeak.boxId)
      else
        positionX = self.x(oldPeak.time)
        positionY = self.y(oldPeak.amplitude)
        console.log 'hi1'
        console.log oldPeak
        self.showPeak(oldPeak.circleId, oldPeak.boxId, oldPeak.amplitude, oldPeak.time, positionX, positionY)

      #increment and switch to new peak
      if self.currentPeak <= 5
        #do trough next so add 5
        self.currentPeak = self.currentPeak + 5
      else
        #do peak next so subtract 4
        self.currentPeak = self.currentPeak - 4

      #show and position the next peak
      newPeak = self.peakConfig[self.currentPeak-1]
      console.log 'hi2'
      console.log newPeak
      positionX = self.x(newPeak.time)
      positionY = self.y(newPeak.amplitude)
      self.showPeak(newPeak.circleId, newPeak.boxId, newPeak.amplitude, newPeak.time, positionX, positionY)
    else
      #come out of peak mode we are done
      self.markPeakMode = no

      #hide last peak if not marked
      peak = self.peakConfig[self.currentPeak-1]
      if not peak.isMarked
        self.hidePeak(peak.circleId, peak.boxId)
      else
        positionX = self.x(peak.time)
        positionY = self.y(peak.amplitude)
        console.log 'hi3'
        console.log peak
        self.showPeak(peak.circleId, peak.boxId, peak.amplitude, peak.time, positionX, positionY)

      #hide info alert
      do hideInfoAlert

      #show cursor
      $('#cursorCircle').css('opacity',1)
      $('#cursorCircle').attr('cx',mouseValues.x)
      $('#cursorCircle').attr('cy',mouseValues.y)

  markPeaks: () ->
    #start from peak 1 and mark each one in sequence
    @multiplePeaks = yes
    @currentPeak = 1
    @markPeakMode = yes

    #show info alert
    showInfoAlert('Mark Peaks & Troughs', '<i>Left Click</i> to mark the peak/trough on the graph and move to next, <i>Right Click</i> to skip/remove the current peak/trough and move to next.')

  markPeak: (peakNumber) ->
    #start from specified peak and no sequence
    @multiplePeaks = no
    @currentPeak = peakNumber
    @markPeakMode = yes

    #convert to roman number
    romanNumber = toRomanNumber(peakNumber)

    #show info alert
    showInfoAlert("Mark Peak & Trough'#{romanNumber}' (#{peakNumber})", '<i>Left Click</i> to mark the peak then the trough on the graph, <i>Right Click</i> to remove the current peak/trough marking.')

  setPeaks: (latency) ->
    @.latency = latency

    if not latency? or not latency.peaks? then return #empty so do nothing

    #hide everything
    for peak in self.peakConfig
      self.hidePeak(peak.circleId, peak.boxId)
      self.hideDelta(Math.abs(peak.number))
      peak.isMarked = no

    #load peaks that exist
    for peak in latency.peaks

      #mark peak in config and get config
      for pc,i in @.peakConfig
        if pc.number is peak.number
          @.peakConfig.isMarked = yes
          @.peakConfig[i].time = peak.time
          @.peakConfig[i].amplitude = peak.amplitude

      peakConfig = _.filter(self.peakConfig, (pd) -> pd.number is peak.number)[0]

      positionX = self.x(peak.time)
      positionY = self.y(peak.amplitude)

      #this function shows all information for the circle point and box
      self.showPeak(peakConfig.circleId, peakConfig.boxId, peak.amplitude, peak.time, positionX, positionY)

      #check for both peak and trough so we can caluclate delta
      @.checkPartnerPeaks(peak.number, peakConfig.type, peakConfig.isMarked)

  checkPartnerPeaks: (peakNumber, peakType, isMarked) ->
    partnerPeak = null
    if peakType is 'peak'
      partnerPeak = self.peakConfig.filter((pc) -> pc.number is (-peakNumber))[0]
    else
      partnerPeak = self.peakConfig.filter((pc) -> pc.number is Math.abs(peakNumber))[0]

    if isMarked
      self.calculateDelta(Math.abs(peakNumber))
    else
      self.hideDelta(Math.abs(peakNumber))

  recordPeak: (peakNumber, time, amplitude) ->
    if @.latency.peaks? then @.latency.peaks = []

    for pc,i in @.peakConfig
      if pc.number is peakNumber
        @.peakConfig.isMarked = yes
        @.peakConfig[i].time = time
        @.peakConfig[i].amplitude = amplitude
    peakConfig = _.filter(self.peakConfig, (pd) -> pd.number is peakNumber)[0]

    #this shows the circle and the box
    positionX = self.x(time)
    positionY = self.y(amplitude)
    self.showPeak(peakConfig.circleId, peakConfig.boxId, amplitude, time, positionX, positionY)

    @.checkPartnerPeaks(peakNumber,peakConfig.type,peakConfig.isMarked)

    foundPeak = no
    for peak,i in @.latency.peaks
      if peak.number is peakNumber
        @.latency.peaks[i].time = time
        @.latency.peaks[i].amplitude = amplitude
        foundPeak = yes

    if not foundPeak
      @.latency.peaks.push {number: peakNumber, time, amplitude}

    @.parent.trigger 'change:latency', @.latency

  clearPeak: (peakNumber) ->
    if @.latency.peaks? then @.latency.peaks = []

    _.each(self.peakConfig, (pc) -> if pc.number is peakNumber then pc.isMarked = no)
    peakConfig = _.filter(self.peakConfig, (pd) -> pd.number is peakNumber)[0]

    @.hidePeak(peakConfig.circleId, peakConfig.boxId)
    @.hideDelta(Math.abs(peakNumber))

    @.checkPartnerPeaks(peakNumber,peakConfig.type,peakConfig.isMarked)

    peaks = []
    for peak in @.latency.peaks
      if peak.number isnt peakNumber
        peaks.push peak
    @.latency.peaks = peaks

  getPeaks: () ->
    return @.latency

module.exports = AbrLatencyAnalyser