(function() {
  var User, line;

  User = require('./userModel');

  line = require('../utils/line');

  exports.create = function(req, res) {
    var user;
    line.debug('User Controller', 'Creating new user');
    user = new User(req.body);
    return user.save(function(err) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(user);
      }
    });
  };

  exports.read = function(req, res) {
    var query;
    line.debug('User Controller', 'Reading User: ', req.params.id);
    query = User.findById(req.params.id);
    return query.exec(function(err, user) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(user);
      }
    });
  };

  exports.update = function(req, res) {
    line.debug('User Controller', 'Updating user: ', req.params.id);
    return User.findByIdAndUpdate(req.params.id, req.body, function(err, user) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(user);
      }
    });
  };

  exports.remove = function(req, res) {
    line.debug('User Controller', 'Removing User: ', req.params.id);
    return User.findByIdAndRemove(req.params.id, function(err, user) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(200);
      }
    });
  };

  exports.query = function(req, res) {
    line.debug('User Controller', 'Querying users: no params');
    return User.find(req.body, function(err, users) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return req.send(users);
      }
    });
  };

}).call(this);
