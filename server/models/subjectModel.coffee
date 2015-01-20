mongoose = require 'mongoose'
Schema = mongoose.Schema

subjectSchema = new Schema
  experiments: [Schema.Types.ObjectId]
  creator: Schema.Types.ObjectId
  created: {type: Date, default: Date.now}
  reference: String
  strain: String
  species: String
  dob: Date
  dod: Date
  fields: Schema.Types.Mixed

subjectSchema.set 'toObject', {virtuals: yes}
subjectSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('Subject', subjectSchema)