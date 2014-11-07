(function() {
  module.exports = function(server) {
    return server.get('/home/', function(req, res) {
      return console.log('home hit');
    });
  };

}).call(this);
