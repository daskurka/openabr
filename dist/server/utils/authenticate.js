(function() {
  var Account, Auth, User, crypto, hashIterations, hashLength, jwt, mongoose, pbkdf2, secret, _;

  mongoose = require('mongoose');

  jwt = require('jwt-simple');

  _ = require('underscore');

  pbkdf2 = require('pbkdf2-sha256');

  crypto = require('crypto');

  User = require('../controllers/userModel');

  Account = require('../controllers/accountModel');

  Auth = require('./authModel');

  secret = 'FbBgywYjx6HPPzjKHqJsDhX8';

  hashIterations = 50000;

  hashLength = 128;

  exports.deserialise = function(req, res, next) {
    req.auth = {};
    if (req.headers.token != null) {
      req.auth.token = jwt.decode(req.headers.token, secret);
      if ((req.auth.token != null) && (req.auth.token.userId != null)) {
        req.auth.authenticated = true;
      } else {
        req.auth.authenticated = false;
        req.auth.error = 'Malformed token';
      }
    } else {
      req.auth.authenticated = false;
      req.auth.error = 'No token';
    }
    return next();
  };

  exports.serialise = function(user) {
    var token;
    token = {
      userId: user._id,
      loginTime: new Date()
    };
    return jwt.encode(token, secret);
  };

  exports.user = function(req, res, next) {
    var userId;
    if (!req.auth.authenticated) {
      return res.send(401, 'Not authorised');
    }
    userId = req.auth.token.userId;
    return User.findOne({
      _id: userId
    }, function(err, user) {
      if ((err != null) || (user == null)) {
        return res.send(401, 'Not authorised');
      }
      req.user = user;
      return next();
    });
  };

  exports.account = function(req, res, next) {
    return exports.user(req, res, function() {
      var urlName;
      urlName = req.params.accountName;
      return Account.findOne({
        urlName: urlName
      }, function(err, account) {
        if ((err != null) || (account == null)) {
          return res.send(401, 'Not Authorised');
        }
        req.account = account;
        req.isUser = _.contains(req.account.users, req.user._id);
        req.isAdmin = _.contains(req.account.admins, req.user._id);
        if (req.isUser || req.isAdmin) {
          return next();
        } else {
          return res.send(401, 'Not Authorised');
        }
      });
    });
  };

  exports.admin = function(req, res, next) {
    return exports.account(req, res, function() {
      if (req.isAdmin) {
        return next();
      } else {
        return res.send(401, 'Not Authorised');
      }
    });
  };

  exports.systemAdmin = function(req, res, next) {
    return exports.user(req, res, function() {
      return Auth.findOne({
        user: req.user._id
      }, function(err, auth) {
        if ((err != null) || (auth == null)) {
          return res.send(401, 'Not Authorised');
        }
        if (auth.isAdmin) {
          return next();
        } else {
          return res.send(401, 'Not Authorised');
        }
      });
    });
  };

  exports.login = function(req, res) {
    var email, password;
    email = req.params.email;
    password = req.params.password;
    return User.findOne({
      email: email
    }, function(err, user) {
      if ((err != null) || (user == null)) {
        console.log(err);
        return res.send(401, 'Not Authorised');
      }
      return Auth.findOne({
        user: user.id
      }, function(err, auth) {
        var resultantHash;
        if (err != null) {
          console.log(err);
          return res.send(401, 'Not Authorised');
        }
        resultantHash = pbkdf2(password, auth.passwordSalt, hashLength, hashIterations);
        resultantHash = resultantHash.toString('base64');
        if (resultantHash === auth.passwordHash) {
          return res.send({
            token: exports.serialise(user),
            isSystemAdmin: auth.isAdmin,
            user: user
          });
        } else {
          return res.send(401, 'Not Authorised');
        }
      });
    });
  };

  exports.createAuthentication = function(userId, password, callback) {
    var auth, hash, salt;
    salt = crypto.randomBytes(hashLength).toString('base64');
    hash = pbkdf2(password, salt, hashLength, hashIterations);
    hash = hash.toString('base64');
    auth = new Auth({
      passwordHash: hash,
      passwordSalt: salt,
      user: userId,
      isAdmin: false
    });
    return auth.save(function(err) {
      if (err != null) {
        return callback(err);
      } else {
        return callback(null, auth);
      }
    });
  };

}).call(this);
