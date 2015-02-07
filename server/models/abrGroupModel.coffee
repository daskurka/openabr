mongoose = require 'mongoose'
Schema = mongoose.Schema

abrGroupSchema = new Schema
  name: String
  number: Number
  ear: String
  date: { type: Date, default: Date.now}
  source: String
  experiments: [Schema.Types.ObjectId] #links to experiments
  creator: Schema.Types.ObjectId #link to user
  created: { type: Date, default: Date.now}

  analysis: Schema.Types.Mixed
  fields: Schema.Types.Mixed

  subjectId: Schema.Types.ObjectId

abrGroupSchema.set 'toObject', {virtuals: yes}
abrGroupSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('AbrGroup', abrGroupSchema)