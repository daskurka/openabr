(function() {
  var Schema, mongoose, userSchema;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  userSchema = new Schema({
    name: String,
    email: String,
    position: String
  });

  module.exports = mongoose.model('User', userSchema);

}).call(this);
