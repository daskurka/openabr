mongoose = require 'mongoose'
Schema = mongoose.Schema

abrReadingSchema = new Schema

  freq: Number
  level: Number
  duration: Number
  sampleRate: Number
  numberSamples: Number

  valueMax: Number
  valueMin: Number
  values: [Number]

  analysis: Schema.Types.Mixed
  fields: Schema.Types.Mixed

  setId: Schema.Types.ObjectId
  subjectId: Schema.Types.ObjectId

abrReadingSchema.set 'toObject', {virtuals: yes}
abrReadingSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('AbrReading', abrReadingSchema)