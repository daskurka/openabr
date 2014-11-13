(function() {
  var chalk, first, mongoose, restify, routes, server;

  restify = require('restify');

  chalk = require('chalk');

  routes = require('./routes');

  mongoose = require('./mongoose');

  first = require('./utils/firstRun');

  server = restify.createServer({
    name: 'openabr-server',
    version: '0.1.0'
  });

  server.port = process.env.PORT || 8080;

  console.log("" + (chalk.red(server.name)) + " is starting...");

  server.use(restify.acceptParser(server.acceptable));

  server.use(restify.queryParser());

  server.use(restify.bodyParser());

  mongoose(server);

  first(server);

  routes(server);

  server.listen(server.port, function() {
    return console.log("" + (chalk.red(server.name)) + " " + (chalk.dim("[" + server.versions + "]")) + " is listening at " + (chalk.blue(server.url)));
  });

}).call(this);
