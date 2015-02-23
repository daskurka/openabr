Collection = require 'ampersand-collection'

FixedDataField = require '../../models/core/fixed-data-field.coffee'

module.exports = Collection.extend

  model: FixedDataField

  addField = (self, col, type, name, dbName, autoPop, required, config, description) ->
    self.add new FixedDataField({col, type, name, dbName, autoPop, description, required, config})

  addFixedFields: (collectionName) ->
    switch collectionName
      when 'subject' then @.addSubjectFields()
      when 'experiment' then @.addExperimentFields()
      when 'abr-group' then @.addAbrGroupFields()
      when 'abr-set' then @.addAbrSetFields()
      when 'abr-reading' then @.addAbrReadingFields()

  addSubjectFields: () ->
    addField(@,'subject','experiments','Experiments','experiments', no,false,null,'Related experiments for this subject.')
    addField(@,'subject','user','Creator','creator', yes,true,null,'Creator / Owner of this subject.')
    addField(@,'subject','date','Created','created', yes,true,null,'Creation date of subject.')
    addField(@,'subject','date','Date of Birth','dob', no,true,null,'Subjects date of birth.')
    addField(@,'subject','date','Date of Death','dod', no,false,null,'Subjects date of death.')
    addField(@,'subject','string','Reference','reference', no,true,null,'User reference for this subject.')
    addField(@,'subject','string','Strain','strain', no,true,null,'Strain of Subject.')
    addField(@,'subject','string','Species','species', no,true,null,'Species of Subject.')

  addExperimentFields: () ->
    addField(@,'experiment','string','Name','name', no,true,null,'Name of the experiment.')
    addField(@,'experiment','string','Description','description', no,false,null,'Description of the experiment.')
    addField(@,'experiment','user','Creator','creator', yes,true,null,'Creator / Owner of this experiment.')
    addField(@,'experiment','date','Created','created', yes,true,null,'Creation date of this experiment.')

  addAbrGroupFields: () ->
    addField(@,'abr-group','string','Name','name', no,false,null,'Name of ABR Group.')
    addField(@,'abr-group','number','Index Number','number', no,true,{unit: '', prefix: ''},'ABR Group index number.')
    addField(@,'abr-group','string','Ear','ear', no,true,null,'Ear of subject used in this ABR Group.')
    addField(@,'abr-group','date','Recording Date','date', no,true,null,'Date this ABR Group was recorded.')
    addField(@,'abr-group','string','Source','source', no,true,null,'Source of this ABR Group.')
    addField(@,'abr-group','experiments','Experiments','experiments', no,false,null,'Related experiments for this ABR Group.')
    addField(@,'abr-group','user','Creator','creator', yes,true,null,'Creator / Owner of this ABR Group.')
    addField(@,'abr-group','date','Created','created', yes,true,null,'Creation date of this ABR Group.')
    addField(@,'abr-group','subject','Subject','subjectId', yes,true,null,'Subject this ABR Group belongs too.')

  addAbrSetFields: () ->
    addField(@,'abr-set','date','Recording Date','date', no,true,null,'Date this ABR Set was recorded.')
    addField(@,'abr-set','boolean','Click Set?','isClick', yes,true,null,'Checked if this ABR Set is a click set.')
    addField(@,'abr-set','number','Frequency','freq', yes,false,{unit: 'Hz', prefix: ''},'ABR Set Frequency when a tone set.')
    addField(@,'abr-set','subject','Subject','subjectId', yes,true,null,'Subject this ABR Set belongs too.')
    addField(@,'abr-set','abr-group','ABR Group','groupId', yes,true,null,'ABR Group this ABR Set belongs too.')
    addField(@,'abr-set','experiments','Experiments','experiments', no,false,null,'Related experiments for this ABR Set.')

  addAbrReadingFields: () ->
    addField(@,'abr-reading','date','Recording Date','date', no,true,null,'Date this ABR Reading was recorded.')
    addField(@,'abr-reading','number','Frequency','freq', yes,false,{unit: 'Hz', prefix: ''},'ABR Reading frequency.')
    addField(@,'abr-reading','number','Level','level', yes,true,{unit: 'B', prefix: 'd'},'ABR Reading level.')
    addField(@,'abr-reading','number','Duration','duration', yes,false,{unit: 's', prefix: 'm'},'ABR Reading duration.')
    addField(@,'abr-reading','number','Sample Rate','sampleRate', yes,true,{unit: 's', prefix: 'm'},'ABR Reading sample rate.')
    addField(@,'abr-reading','number','Number Samples','numberSamples', yes,true,{unit: '', prefix: ''},'ABR Reading sample count.')
    addField(@,'abr-reading','number','Value Max','valueMax', yes,true,{unit: 'V', prefix: 'u'},'ABR Reading max amplitude.')
    addField(@,'abr-reading','number','Value Min','valueMin', yes,true,{unit: 'V', prefix: 'u'},'ABR Reading min amplitude.')
    addField(@,'abr-reading','values','Raw ABR Values','values', yes,true,null,'Raw ABR Values.')
    addField(@,'abr-reading','subject','Subject','subjectId', yes,true,null,'Subject this ABR Reading belongs too.')
    addField(@,'abr-reading','abr-set','ABR Set','setId', yes,true,null,'ABR Set this ABR Reading belongs too.')
    addField(@,'abr-reading','experiments','Experiments','experiments', no,false,null,'Related experiments for this ABR Reading.')


