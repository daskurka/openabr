(function() {
  var Account, User, isCurrentUser, line;

  User = require('./userModel');

  Account = require('./accountModel');

  line = require('../utils/line');

  isCurrentUser = function(req, res, next) {
    var requestUserId;
    requestUserId = req.params.id;
    if (req.auth.token.userId !== requestUserId) {
      return res.send(401, 'Not authorised');
    } else {
      return next();
    }
  };

  exports.read = function(req, res) {
    return isCurrentUser(req, res, function() {
      var query;
      line.debug('Profile Controller', 'Reading User: ', req.params.id);
      query = User.findById(req.params.id);
      return query.exec(function(err, user) {
        if (err != null) {
          return res.send(500, "Internal Server Error: " + err);
        } else {
          return res.send(user);
        }
      });
    });
  };

  exports.update = function(req, res) {
    return isCurrentUser(req, res, function() {
      line.debug('Profile Controller', 'Updating user: ', req.params.id);
      return User.findByIdAndUpdate(req.params.id, req.body, function(err, user) {
        if (err != null) {
          return res.send(500, "Internal Server Error: " + err);
        } else {
          return res.send(user);
        }
      });
    });
  };

  exports.queryAccounts = function(req, res) {
    return isCurrentUser(req, res, function() {
      var query;
      line.debug('Profile Controller', 'Finding user accounts: ', req.params.id);
      query = Account.find();
      query.or([
        {
          users: req.params.id
        }, {
          admins: req.params.id
        }
      ]);
      return query.exec(function(err, accounts) {
        if (err != null) {
          return res.send(500, "Internal Server Error: " + err);
        } else {
          return res.send(accounts);
        }
      });
    });
  };

}).call(this);
