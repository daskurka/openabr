(function() {
  var Account, line;

  Account = require('./accountModel');

  line = require('../utils/line');

  exports.read = function(req, res) {
    line.debug('Account Controller', 'Reading account: ', req.params.accountName);
    return res.send(req.account);
  };

  exports.update = function(req, res) {
    line.debug('Account Controller', 'Updating account: ', req.params.accountName);
    return Account.findByIdAndUpdate(req.account.id, req.body, function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(account);
      }
    });
  };

  exports.remove = function(req, res) {
    line.debug('Account Controller', 'Removing account: ', req.params.accountName);
    return req.account.remove(function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(200);
      }
    });
  };

}).call(this);
