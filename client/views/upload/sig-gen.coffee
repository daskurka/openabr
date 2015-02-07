View = require 'ampersand-view'
CollectionView = require 'ampersand-collection-view'
_ = require 'lodash'
select2 = require 'select2'
DataStream = require '../../utils/data-stream'
templates = require '../../templates'
GroupView = require './group-view.coffee'

AbrGroupModel = require '../../models/core/abr-group.coffee'
AbrSetModel = require '../../models/core/abr-set.coffee'
AbrReadingModel = require '../../models/core/abr-reading.coffee'

AbrGroupCollection = require '../../collections/core/abr-groups.coffee'
AbrSetCollection = require '../../collections/core/abr-sets.coffee'
AbrReadingCollection = require '../../collections/core/abr-readings.coffee'

module.exports = View.extend

  template: templates.views.upload.sigGen

  #SigGen Limits
  MaxGroups = 200
  MaxRecordings = 2000
  MaxCursors = 10
  MaxVariables = 10

  derived:
    researcher:
      deps: ['model.creator']
      fn: () -> return app.lookup.user(@.model.creator).name
    uploadDate:
      deps: ['model.created']
      fn: () -> return @.model.created.toISOString().split('T')[0]

  bindings:
    'researcher': '[data-hook~=upload-user]'
    'uploadDate': '[data-hook~=upload-date]'
    'model.date': '[data-hook~=abr-date]'

  props:
      array: 'object' #ArrayBuffer
      filename: 'string'

  initialize: () ->
    reader = new DataStream(@.array)

    #todo check and update user fields for SigGen

    model = new AbrModel()
    model.source = 'BioSig Arf File'
    model.creator = app.me.user.id
    model.created = new Date()
    model.fields = {}
    model.fields.sg_ftype = reader.readInt16()
    model.fields.filename = @.filename

    numberGroups = reader.readInt16()
    numberRecordings = reader.readInt16()

    groupSeekPositions = []
    for i in [0...MaxGroups]
      if i < numberGroups
        groupSeekPositions.push reader.readInt32()
      else
        reader.readInt32() #advance pointer

    recordingSeekPositions = []
    for i in [0...MaxRecordings]
      if i < numberRecordings
        recordingSeekPositions.push reader.readInt32()
      else
        reader.readInt32() #advance pointer

    reader.readInt32() #file pointer handle

    model.groups = new AbrGroupCollection()

    for groupCount in [0...numberGroups]
      group = new AbrGroupModel()

      group.fields = {}
      group.number = group.fields.sg_grpn = reader.readInt16()
      reader.readInt16() #frecn
      group.fields.sg_nrecs = reader.readInt16()
      group.fields.sg_sbjid = reader.readString(16)
      group.fields.sg_ref1 = reader.readString(16)
      group.fields.sg_ref2 = reader.readString(16)
      group.fields.sg_memo = reader.readString(50)
      startTime = reader.readString(8)
      endTime = reader.readString(8)
      group.fields.sg_fn1 = reader.readString(100)
      group.fields.sg_fn2 = reader.readString(100)

      #console.log 'Start Time: ' + startTime
      #console.log 'End Time: ' + endTime

      variableIndex = new Array(MaxVariables)
      isClickGroup = yes
      for i in [0...MaxVariables]
        name = reader.readString(15).replace(/\0/g,'') #SigGen uses null chars instead of spaces
        if name? and name.length > 0
          variableIndex[i] = name
          if name is 'Freq' then isClickGroup = no #sig gen group can apparently only be one or the other
        else
          variableIndex[i] = null
      for i in [0...MaxVariables]
        reader.readString(5) #unit for variables

      group.fields.sg_srate = reader.readFloat32()
      group.fields.sg_cctyp = reader.readInt32()
      group.fields.sg_ver = reader.readInt16()
      group.fields.sg_postp = reader.readInt32()
      group.fields.sg_dump = reader.readString(92)

      group.sets = new AbrSetCollection()

      groupSeekPosition = groupSeekPositions[groupCount]
      firstReadingPosition = null
      recordingPositions = _.sortBy(recordingSeekPositions, (n) -> n)
      for pos in recordingPositions
        if pos > groupSeekPosition
          firstReadingPosition = pos
          break;

      reader.seek(firstReadingPosition)

      #groups are more structural organisation, they differ in setup/rig changes (ear, microphone placement etc)
      #sets are for a group of level changes, for example click, 4l, 8k and 16k would be sets of the same group
      #readings are the individual recordings

      readings = new AbrReadingCollection()
      recordingsInGroup = getRecordingsInGroup(groupCount,numberGroups, groupSeekPositions, recordingSeekPositions)

      for i in [0...recordingsInGroup]
        reading = new AbrReadingModel()
        reading.fields = {}
        reading.fields.sg_recn = reader.readInt16()
        reader.readInt16() #skip grpid
        reader.readFloat64() #skip grp_t
        reader.readInt16() #skip newgrp
        reading.fields.sg_sgi = reader.readInt16()
        reading.fields.sg_chan = reader.readString(1)
        reading.fields.sg_rtype = reader.readString(1)
        reading.numberSamples = reading.fields.sg_npts = reader.readInt16()
        reading.fields.sg_osdel = reader.readFloat32()
        reading.duration = reading.fields.sg_dur = reader.readFloat32()
        reading.sampleRate = reading.fields.sg_srate = reader.readFloat32()
        reader.readFloat32() #skip arthresh
        reader.readFloat32() #skip gain
        reader.readInt16() #skip accouple
        reading.fields.sg_navgs = reader.readInt16()
        reading.fields.sg_narts = reader.readInt16()
        startTime = reader.readString(8)
        endTime = reader.readString(8)

        for i in [0...MaxVariables]
          switch variableIndex[i]
            when 'Freq'
              reading.freq = reader.readFloat32()
            when 'Level'
              reading.level = reader.readFloat32()
            when 'Phase'
              reading.fields.sg_phase = reader.readFloat32()
            when 'Duration','GateTime','Atten-A'
              reader.readFloat32() #skip
            else
              reader.readFloat32() #also skip

        for i in [0...MaxCursors]
          #not recording these so lets just run through them
          reader.readFloat32() #mark
          reader.readFloat32() #value
          reader.readString(20) #description
          reader.readInt16() #xpos
          reader.readInt16() #ypos
          reader.readInt16() #hide
          reader.readInt16() #lock

        reading.values = new Array(reading.numberSamples)
        for i in [0...reading.numberSamples]
          reading.values[i] = reader.readFloat32()

        reading.maxValue = _.max(reading.values)
        reading.minValue = _.min(reading.values)

        readings.add reading

      if isClickGroup
        clickSet = new AbrSetModel()
        clickSet.readings = readings
        clickSet.isClick = yes
        group.sets.add clickSet
        group.name = "Click - #{group.sets.length} Set(s)"
      else
        frequencies = _.uniq(readings.map((reading) -> reading.freq))
        for freq in frequencies
          freqSet = new AbrSetModel()
          freqSet.readings = readings.filter (reading) -> reading.freq is freq
          freqSet.frequency = freq
          freqSet.isClick = no
          group.sets.add freqSet
        group.name = "Tone - #{group.minFreq/1000} kHz to #{group.maxFreq/1000} kHz"

      model.groups.add group

    @.model = model

  subviews:
    sets:
      hook: 'groups-display'
      waitFor: 'model'
      prepareView: (el) ->
        return new CollectionView(el: el, collection: @.model.groups, view: GroupView)

  getRecordingsInGroup = (group, totalGroups, groupPositions, recordingPositions) ->
    groupSeekPosition = groupPositions[group]

    if totalGroups is (group + 1)
      #last group
      return _.filter(recordingPositions, (num) -> num > groupSeekPosition).length

    #first or middle group
    nextGroupSeekPosition = groupPositions[group + 1]
    return _.filter(recordingPositions, (num) -> nextGroupSeekPosition > num > groupSeekPosition).length