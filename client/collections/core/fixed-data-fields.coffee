Collection = require 'ampersand-collection'

FixedDataField = require '../../models/core/fixed-data-field.coffee'

module.exports = Collection.extend

  model: FixedDataField

  addField = (self, col, type, name, dbName, autoPop, required, config, description) ->
    self.add new FixedDataField({col, type, name, dbName, autoPop, description, required, config})

  addFixedFields: (collectionName) ->
    switch collectionName
      when 'subject' then @.addSubjects()
      when 'experiment' then @.addExperiment()

  addSubjects: () ->
    addField(@,'subject','experiments','Experiments','experiments', no,false,null,'Related experiments for this subject.')
    addField(@,'subject','user','Creator','creator', yes,true,null,'Creator / Owner of this subject.')
    addField(@,'subject','date','Created','created', yes,true,null,'Creation date of subject.')
    addField(@,'subject','date','Date of Birth','dob', no,true,null,'Subjects date of birth.')
    addField(@,'subject','date','Date of Death','dod', no,false,null,'Subjects date of death.')
    addField(@,'subject','string','Reference','reference', no,true,null,'User reference for this subject.')
    addField(@,'subject','string','Strain','strain', no,true,null,'Strain of Subject.')
    addField(@,'subject','string','Species','species', no,true,null,'Species of Subject.')

  addExperiment: () ->
    addField(@,'experiment','string','Name','name', no,true,null,'Name of the experiment.')
    addField(@,'experiment','string','Description','description', no,false,null,'Description of the experiment.')
    addField(@,'experiment','user','Creator','creator', yes,true,null,'Creator / Owner of this experiment.')

