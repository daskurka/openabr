(function() {
  var Schema, accountSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  accountSchema = new Schema({
    name: String,
    urlName: String,
    address: String,
    contact: String,
    notes: String,
    suspended: Boolean,
    suspendedNotice: String,
    users: [Schema.Types.ObjectId],
    admins: [Schema.Types.ObjectId]
  });

  module.exports = mongoose.model('Account', accountSchema);

}).call(this);
