mongoose = require 'mongoose'
Schema = mongoose.Schema

experimentSchema = new Schema
  name: String
  description: String
  creator: Schema.Types.ObjectId
  fields: Schema.Types.Mixed

experimentSchema.set 'toObject', {virtuals: yes}
experimentSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('Experiment', experimentSchema)