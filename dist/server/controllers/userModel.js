(function() {
  var Schema, mongoose, userSchema;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  userSchema = new Schema({
    name: String,
    email: String,
    position: String
  });

  userSchema.set('toObject', {
    virtuals: true
  });

  userSchema.set('toJSON', {
    virtuals: true
  });

  module.exports = mongoose.model('User', userSchema);

}).call(this);
