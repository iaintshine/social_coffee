// Generated by CoffeeScript 1.4.0
(function() {
  var Handler, Processor, assert, logger, thrift, ttypes;

  ttypes = require('./social_coffee_service_types');

  Processor = require('./SocialCoffeeService');

  Handler = require('./handler');

  assert = require('assert');

  thrift = require('node-thrift');

  logger = require('winston');

  SocialCoffee.Thrift.Server = (function() {

    function Server() {
      this.server = null;
    }

    Server.prototype.start = function(options, callback) {
      var thrift_options;
      assert(options, "This function call requires options");
      assert(options.port && typeof options.port === 'number' && options.port >= 0, "port value is invalid or missing");
      thrift_options = {
        transport: thrift.TFramedTransport,
        protocol: thrift.TBinaryProtocol
      };
      this.server = thrift.createServer(Processor, Handler, thrift_options);
      this.server.on('listening', function() {
        return logger.info("Social Coffee Thrift server socket has been bound");
      });
      this.server.on('connection', function(socket) {
        return logger.info("New client connection accepted from " + socket.remoteAddress + ":" + socket.remotePort);
      });
      this.server.on('close', function() {
        return logger.warn("Social Coffee Thfit server has been closed.");
      });
      this.server.on('error', function(error) {
        return logger.error("Error occurred during thrift server operation", {
          error: err.toString()
        });
      });
      return this.server.listen(options.port, function() {
        logger.info("Social Coffee Thrift server is listening at port " + options.port);
        if ((callback != null) && typeof callback === 'function') {
          return callback();
        }
      });
    };

    Server.prototype.stop = function(callback) {
      if (this.server != null) {
        logger.info("Closing Social Coffee Thrift server ...");
        return this.server.close(function() {
          logger.info("Social Coffee thrift server is closed. No more connections will be accepted.");
          if ((callback != null) && typeof callback === 'function') {
            callback();
          }
          return this.server = null;
        });
      }
    };

    return Server;

  })();

  exports.Server = SocialCoffee.Thrift.Server;

}).call(this);