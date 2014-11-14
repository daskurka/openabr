(function() {
  var Account, Auth, User, isCurrentUser, line;

  User = require('./userModel');

  Account = require('./accountModel');

  Auth = require('../utils/authModel');

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
      line.debug('Profile Controller', 'Reading User: ', req.params.id);
      return Auth.findOne({
        user: req.params.id
      }, function(err, auth) {
        var result;
        if (err != null) {
          return res.send(500, "Internal Server Error: " + err);
        } else {
          result = req.user.toJSON();
          result.isSystemAdmin = auth.isAdmin;
          return res.send(result);
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
