(function() {
  var account, accountUser, authenticate, user;

  authenticate = require('./utils/authenticate');

  account = require('./controllers/accountController');

  accountUser = require('./controllers/accountUserController');

  user = require('./controllers/userController');

  module.exports = function(server) {
    server.use(authenticate.deserialise);
    server.get('/auth/login', authenticate.login);
    server.post('/admin/accounts', authenticate.systemAdmin, account.create);
    server.get('/admin/accounts/:id', authenticate.systemAdmin, account.read);
    server.put('/admin/accounts/:id', authenticate.systemAdmin, account.update);
    server.del('/admin/accounts/:id', authenticate.systemAdmin, account.remove);
    server.get('/admin/accounts', authenticate.systemAdmin, account.query);
    server.post('/admin/users', authenticate.systemAdmin, user.create);
    server.get('/admin/users/:id', authenticate.systemAdmin, user.read);
    server.put('/admin/users/:id', authenticate.systemAdmin, user.update);
    server.del('/admin/users/:id', authenticate.systemAdmin, user.remove);
    server.get('/admin/users', authenticate.systemAdmin, user.query);
    server.post('/:accountName/users', authenticate.admin, accountUser.create);
    server.get('/:accountName/users/:id', authenticate.admin, accountUser.read);
    server.put('/:accountName/users/:id', authenticate.admin, accountUser.update);
    server.del('/:accountName/users/:id', authenticate.admin, accountUser.remove);
    return server.get('/:accountName/users', authenticate.account, accountUser.query);
  };

}).call(this);
