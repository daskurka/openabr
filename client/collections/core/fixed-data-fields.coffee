Collection = require 'ampersand-collection'

FixedDataField = require '../../models/core/fixed-data-field.coffee'

module.exports = Collection.extend

  model: FixedDataField

  addField = (self, col, type, name, dbName, suffix, required, config, description) ->
    self.add new FixedDataField({col, type, name, dbName, suffix, description, required, config})

  addFixedFields: (collectionName) ->
    switch collectionName
      when 'subject' then @.addSubjects()
      when 'experiment' then @.addExperiment()

  addSubjects: () ->
    addField(@,'subject','experiments','Experiments','experiments', null,false,null,'Related experiments for this subject.')
    addField(@,'subject','user','Creator','creator', null,true,null,'Creator / Owner of this subject.')
    addField(@,'subject','date','Created','created', null,true,null,'Creation date of subject.')
    addField(@,'subject','date','Date of Birth','dob', null,false,null,'Subjects date of birth.')
    addField(@,'subject','date','Date of Death','dod', null,false,null,'Subjects date of death.')
    addField(@,'subject','string','Reference','reference', null,true,null,'User reference for this subject.')
    addField(@,'subject','string','Strain','strain', null,true,null,'Strain of Subject.')
    addField(@,'subject','string','Species','species', null,true,null,'Species of Subject.')

  addExperiment: () ->
    addField(@,'experiment','string','Name','name', null,true,null,'Name of the experiment.')
    addField(@,'experiment','string','Description','description', null,false,null,'Description of the experiment.')
    addField(@,'experiment','user','Creator','creator', null,true,null,'Creator / Owner of this experiment.')

