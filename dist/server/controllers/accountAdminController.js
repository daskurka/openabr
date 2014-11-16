(function() {
  var Account, line;

  Account = require('./accountModel');

  line = require('../utils/line');

  exports.create = function(req, res) {
    var account;
    line.debug('Account Admin Controller', 'Creating new account');
    account = new Account(req.body);
    return account.save(function(err) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(account);
      }
    });
  };

  exports.read = function(req, res) {
    var query;
    line.debug('Account Admin Controller', 'Reading account: ', req.params.id);
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
    line.debug('Account Admin Controller', 'Updating account: ', req.params.id);
    return Account.findByIdAndUpdate(req.params.id, req.body, function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(account);
      }
    });
  };

  exports.remove = function(req, res) {
    line.debug('Account Admin Controller', 'Removing account: ', req.params.id);
    return Account.findByIdAndRemove(req.params.id, function(err, account) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(200);
      }
    });
  };

  exports.query = function(req, res) {
    line.debug('Account Admin Controller', 'Querying accounts: no params');
    return Account.find(req.params, function(err, accounts) {
      if (err != null) {
        return res.send(500, "Internal Server Error: " + err);
      } else {
        return res.send(accounts);
      }
    });
  };

}).call(this);
