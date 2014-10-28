(function() {
  var port, restify, server;

  restify = require('restify');

  port = process.env.PORT || 8080;

  server = restify.createServer();

  server.get('/test/:name', function(req, res, next) {
    res.send('Hello there... ' + req.params.name);
    return next();
  });

  server.listen(port, function() {
    return console.log('%s listening at %s', server.name, server.url);
  });

}).call(this);
