mongoose = require 'mongoose'
Schema = mongoose.Schema

abrGroupSchema = new Schema

  type: String
  name: String
  number: Number
  ear: String
  date: { type: Date, default: Date.now}
  source: String
  creator: Schema.Types.ObjectId #link to user
  created: { type: Date, default: Date.now}

  analysis: Schema.Types.Mixed
  fields: Schema.Types.Mixed

  subjectId: Schema.Types.ObjectId
  experiments: [Schema.Types.ObjectId] #links to experiments

  tags: [String]

abrGroupSchema.set 'toObject', {virtuals: yes}
abrGroupSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('AbrGroup', abrGroupSchema)