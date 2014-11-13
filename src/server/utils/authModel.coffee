mongoose = require 'mongoose'
Schema = mongoose.Schema

authSchema = new Schema
  user: Schema.Types.ObjectId
  passwordHash: String
  passwordSalt: String
  isAdmin: Boolean

authSchema.set 'toObject', {virtuals: yes}
authSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('Auth', authSchema)