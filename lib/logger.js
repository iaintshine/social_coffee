// Generated by CoffeeScript 1.4.0
(function() {
  var Environment, KnownPath, Logger, fs, logger, path;

  Environment = require('./environment');

  KnownPath = require('./known_path');

  path = require('path');

  fs = require('fs');

  logger = require('winston');

  Logger = (function() {

    function Logger() {}

    Logger.output_path = function() {
      var file_name;
      file_name = "" + Environment.env + ".log";
      return path.join(KnownPath.log, file_name);
    };

    Logger.prepare_fs = function() {
      if (!fs.existsSync(KnownPath.log)) {
        return fs.mkdirSync(KnownPath.log);
      }
    };

    Logger.say_hi = function() {
      return logger.info("You are running in " + Environment.env + " environment");
    };

    Logger.initialize = function() {
      var options;
      this.prepare_fs();
      logger.clear();
      if (!Environment.production) {
        logger.add(logger.transports.Console, {
          colorize: true,
          label: process.pid
        });
      }
      options = {
        filename: this.output_path(),
        json: false,
        timestamp: false,
        label: process.pid
      };
      logger.add(logger.transports.File, options);
      return this.say_hi();
    };

    return Logger;

  })();

  module.exports = Logger;

}).call(this);
