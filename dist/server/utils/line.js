(function() {
  var chalk;

  chalk = require('chalk');

  exports.debug = function(prefix, text, id) {
    var idPart;
    idPart = id != null ? chalk.cyan(id) : '';
    return console.log("" + (chalk.blue(prefix)) + " - " + (chalk.green(text)) + idPart);
  };

}).call(this);
