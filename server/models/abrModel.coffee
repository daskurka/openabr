mongoose = require 'mongoose'
Schema = mongoose.Schema

abrSchema = new Schema
  state: String
  experiments: [Schema.Types.ObjectId]
  uploader: Schema.Types.ObjectId
  uploaded: {type: Date, default: Date.now}
  subject: {
    id: Schema.Types.ObjectId
    reference: String
    strain: String
    species: String
  }
  groups: [{
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