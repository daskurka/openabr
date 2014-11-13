(function() {
  var Account, line;

  Account = require('./accountModel');

  line = require('../utils/line');

  exports.read = function(req, res) {
    var query;
    line.debug('Account Controller', 'Reading account: ', req.params.id);
    query = Account.findById(req.params.id);
    return query.exec(function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(account);
      }
    });
  };

  exports.update = function(req, res) {
    line.debug('Account Controller', 'Updating account: ', req.params.id);
    return Account.findByIdAndUpdate(req.params.id, req.body, function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(account);
      }
    });
  };

  exports.remove = function(req, res) {
    line.debug('Account Controller', 'Removing account: ', req.params.id);
    return Account.findByIdAndRemove(req.params.id, function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(200);
      }
    });
  };

}).call(this);
