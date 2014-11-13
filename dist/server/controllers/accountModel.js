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

  accountSchema.set('toObject', {
    virtuals: true
  });

  accountSchema.set('toJSON', {
    virtuals: true
  });

  module.exports = mongoose.model('Account', accountSchema);

}).call(this);
