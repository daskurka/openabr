mongoose = require 'mongoose'
Schema = mongoose.Schema

dataFieldSchema = new Schema
  col: String
  type: String
  name: String
  dbName: String
  description: String
  required: Boolean
  creator: Schema.Types.ObjectId
  created: { type: Date, default: Date.now}
  config: Schema.Types.Mixed
  locked: Boolean
  autoPop: Boolean

dataFieldSchema.set 'toObject', {virtuals: yes}
dataFieldSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('DataField', dataFieldSchema)