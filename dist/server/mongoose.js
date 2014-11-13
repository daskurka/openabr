(function() {
  var mongoose;

  mongoose = require('mongoose');

  module.exports = function(server) {
    mongoose.connect('mongodb://localhost/dev');
    require('./controllers/accountModel');
    require('./controllers/userModel');
    return require('./utils/authModel');
  };

}).call(this);
