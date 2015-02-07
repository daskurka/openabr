mongoose = require 'mongoose'
Schema = mongoose.Schema

abrGroupSchema = new Schema
  name: String
  number: Number
  ear: String
  date: Schema.Types.Date
  source: String
  experiments: [Schema.Types.ObjectId] #links to experiments
  creator: Schema.Types.ObjectId #link to user
  created: Schema.Types.Date

  analysis: Schema.Types.Mixed
  fields: Schema.Types.Mixed

  subjectId: Schema.Types.ObjectId

abrGroupSchema.set 'toObject', {virtuals: yes}
abrGroupSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('AbrGroup', abrGroupSchema)