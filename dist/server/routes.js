(function() {
  var account, accountAdmin, accountUser, authenticate, profile, userAdmin;

  authenticate = require('./utils/authenticate');

  accountAdmin = require('./controllers/accountAdminController');

  userAdmin = require('./controllers/userAdminController');

  account = require('./controllers/accountController');

  accountUser = require('./controllers/accountUserController');

  profile = require('./controllers/profileController');

  module.exports = function(server) {
    server.use(authenticate.deserialise);
    server.get('/auth/login', authenticate.login);
    server.get('/admin/accounts/lookup/:urlName', authenticate.systemAdmin, accountAdmin.lookup);
    server.post('/admin/accounts', authenticate.systemAdmin, accountAdmin.create);
    server.get('/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.read);
    server.put('/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.update);
    server.del('/admin/accounts/:id', authenticate.systemAdmin, accountAdmin.remove);
    server.get('/admin/accounts', authenticate.systemAdmin, accountAdmin.query);
    server.post('/admin/users', authenticate.systemAdmin, userAdmin.create);
    server.get('/admin/users/:id', authenticate.systemAdmin, userAdmin.read);
    server.put('/admin/users/:id', authenticate.systemAdmin, userAdmin.update);
    server.del('/admin/users/:id', authenticate.systemAdmin, userAdmin.remove);
    server.get('/admin/users', authenticate.systemAdmin, userAdmin.query);
    server.get('/profile/:id', authenticate.user, profile.read);
    server.put('/profile/:id', authenticate.user, profile.update);
    server.get('/profile/:id/accounts', authenticate.user, profile.queryAccounts);
    server.get('/:accountName', authenticate.account, account.read);
    server.put('/:accountName', authenticate.admin, account.update);
    server.del('/:accountName', authenticate.admin, account.remove);
    server.post('/:accountName/users', authenticate.admin, accountUser.create);
    server.get('/:accountName/users/:id', authenticate.account, accountUser.read);
    server.put('/:accountName/users/:id', authenticate.admin, accountUser.update);
    server.del('/:accountName/users/:id', authenticate.admin, accountUser.remove);
    return server.get('/:accountName/users', authenticate.account, accountUser.query);
  };

}).call(this);
