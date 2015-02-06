mongoose = require 'mongoose'
Schema = mongoose.Schema

abrSchema = new Schema
  state: String
  experiments: [Schema.Types.ObjectId]
  creator: Schema.Types.ObjectId
  created: {type: Date, default: Date.now}
  subject: {
    id: Schema.Types.ObjectId
    reference: String
    strain: String
    species: String
  }
  date: {type: Date, default: Date.now}
  source: String #SigGen, push, can be anything but must be consistant
  groups: [{
    dateTime: {type: Date, default: Date.now}
    sets: [{
      readings: [{
        fields: Schema.Types.Mixed
      }]
      fields: Schema.Types.Mixed
    }]
    fields: Schema.Types.Mixed
  }]
  fields: Schema.Types.Mixed

abrSchema.set 'toObject', {virtuals: yes}
abrSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('Abr', abrSchema)