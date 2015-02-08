math = require 'mathjs'

module.exports = (abrs) -> #as AbrReadingCollection

  #find middle of samples
  sampleCount = abrs.models[0].numberSamples
  splitPoint = Math.floor(sampleCount/2)

  #get noise values
  noiseValues = abrs.map (abr) -> return math.std(abr.values[splitPoint..])
  medianNoise = math.median(noiseValues)
  threshold = medianNoise*4

  #find peak
  thresholdAbrReading = null
  abrs.each (abr) ->

    min = math.abs(abr.valueMin)
    max = math.abs(abr.valueMax)
    peak = if min > max then min else max

    if peak > threshold

      #we found an abr reading that is above the threshold
      if thresholdAbrReading is null
        thresholdAbrReading = abr
      else
        if thresholdAbrReading.level > abr.level
          thresholdAbrReading = abr

  #we now return the lows level that blew the threshold
  #if this value is null then there was no significate peak
  return thresholdAbrReading



