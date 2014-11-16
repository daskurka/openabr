(function() {
  var User, line;

  User = require('./userModel');

  line = require('../utils/line');

  exports.create = function(req, res) {
    var user;
    line.debug('User Admin Controller', 'Creating new user');
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
    line.debug('User Admin Controller', 'Reading User: ', req.params.id);
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
    line.debug('User Admin Controller', 'Updating user: ', req.params.id);
    return User.findByIdAndUpdate(req.params.id, req.body, function(err, user) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(user);
      }
    });
  };

  exports.remove = function(req, res) {
    line.debug('User Admin Controller', 'Removing User: ', req.params.id);
    return User.findByIdAndRemove(req.params.id, function(err, user) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(200);
      }
    });
  };

  exports.query = function(req, res) {
    var innerPart, part;
    line.debug('User Admin Controller', 'Querying users: no params');
    for (part in req.params) {
      for (innerPart in req.params[part]) {
        if (innerPart === '$regex') {
          if (req.params[part]['$options'] != null) {
            req.params[part] = new RegExp(req.params[part]['$regex'], req.params[part]['$options']);
          } else {
            req.params[part] = new RegExp(req.params[part]['$regex']);
          }
        }
      }
    }
    return User.find(req.params, function(err, users) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(users);
      }
    });
  };

}).call(this);
