mongoose = require 'mongoose'
Schema = mongoose.Schema

userSchema = new Schema
  name: String
  email: String
  position: String

userSchema.set 'toObject', {virtuals: yes}
userSchema.set 'toJSON', {virtuals: yes}

module.exports = mongoose.model('User', userSchema)