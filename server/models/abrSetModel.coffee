mongoose = require 'mongoose'
Schema = mongoose.Schema

abrSetSchema = new Schema

  isClick: Boolean
  freq: Number

  analysis: Schema.Types.Mixed
  fields: Schema.Types.Mixed

  groupId: Schema.Types.ObjectId
  subjectId: Schema.Types.ObjectId
  experiments: [Schema.Types.ObjectId] #links to experiments

  tags: [String]

abrSetSchema.set 'toObject', {virtuals: yes}
abrSetSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('AbrSet', abrSetSchema)