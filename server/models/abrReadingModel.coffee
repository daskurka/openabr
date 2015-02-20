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
  experiments: [Schema.Types.ObjectId] #links to experiments
  date: { type: Date, default: Date.now} #duplicate of group date for faster searching

  tags: [String]

abrReadingSchema.set 'toObject', {virtuals: yes}
abrReadingSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('AbrReading', abrReadingSchema)