(function() {
  var Account, User, async, authenticate, line;

  async = require('async');

  line = require('./line');

  Account = require('../controllers/accountModel');

  User = require('../controllers/userModel');

  authenticate = require('./authenticate');

  module.exports = function(server) {
    return User.count({}, function(err, userCount) {
      var admin;
      if (err != null) {
        return console.log(err);
      }
      if (userCount <= 0) {
        admin = {
          name: 'Samuel Kirkpatrick',
          email: 'admin@openabr.com',
          position: 'Administrator'
        };
        return User.create(admin, function(err, user) {
          if (err != null) {
            return console.log(err);
          }
          return authenticate.createAuthentication(user.id, 'password', function(err) {
            var demo;
            if (err != null) {
              return console.log(err);
            }
            demo = {
              name: 'Demo Lab',
              urlName: 'demolab',
              address: 'This is a demo address, as such it is not very long.',
              contact: 'This is a demo contact detail.',
              notes: 'Demo account!',
              suspended: false,
              suspendedNotice: '',
              users: [],
              admins: []
            };
            demo.admins.push(user.id);
            return Account.create(demo, function(err) {
              if (err != null) {
                return console.log(err);
              }
            });
          });
        });
      }
    });
  };

}).call(this);
