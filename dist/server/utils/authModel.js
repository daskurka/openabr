(function() {
  var Schema, authSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  authSchema = new Schema({
    user: Schema.Types.ObjectId,
    passwordHash: String,
    passwordSalt: String,
    isAdmin: Boolean
  });

  module.exports = mongoose.model('Auth', authSchema);

}).call(this);
