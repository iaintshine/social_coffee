// Generated by CoffeeScript 1.4.0
(function() {
  var Database, Environment, Hookable, Module, assert, logger, redis,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Environment = require('./environment');

  Module = require('./module');

  assert = require('assert');

  logger = require('winston');

  redis = require('redis');

  Hookable = {
    hooks: {},
    on: function(event, callback) {
      var _base, _ref;
      assert(event && typeof event === 'string', "event must be a string");
      assert(callback && callback instanceof Function, "This function call requires a callback");
      return ((_ref = (_base = this.hooks)[event]) != null ? _ref : _base[event] = []).push(callback);
    },
    emit: function() {
      var args, event, hook, _i, _len, _ref, _results;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      assert(event && typeof event === 'string', "event must be a string");
      if (this.hooks[event]) {
        _ref = this.hooks[event];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          hook = _ref[_i];
          _results.push(hook.apply(null, args));
        }
        return _results;
      }
    }
  };

  Database = (function(_super) {

    __extends(Database, _super);

    function Database() {
      return Database.__super__.constructor.apply(this, arguments);
    }

    Database.connected = false;

    Database.connection = null;

    Database.config = null;

    Database.url = null;

    Database.current_db = function() {
      if ((Database.config != null) && (Database.config.database != null)) {
        return Database.config.database;
      } else {
        return 0;
      }
    };

    Database.extend(Hookable);

    Database.after_connect = function() {
      return Database.emit('connect', Database.connection);
    };

    Database.after_disconnect = function() {
      return Database.emit('close', Database.connection);
    };

    Database.check_config = function(config) {
      assert(config, "This function requires config");
      assert(config.host && typeof config.host === 'string', "host configuration is invalid or missing");
      assert(config.port && typeof config.port === 'number' && config.port >= 0, "port configuration is invalid or missing");
      if (config.database != null) {
        assert(typeof config.database === 'number', "Redis database index must be a number");
        assert(config.database >= 0, "Redis database index must be greater than or equal to 0");
      }
      if (config.password != null) {
        assert(typeof config.password === 'string', "Redis auth password must be a string");
        return assert(config.password.length > 0, "Redis auth password must be of length greater than 0");
      }
    };

    Database.connect = function(config, callback) {
      var options;
      if (Database.connected) {
        return;
      }
      Database.check_config(config);
      Database.url = "tcp://" + config.host + ":" + config.port;
      logger.info("Connecting to redis instance at " + Database.url + " ...");
      options = {
        parser: 'hiredis'
      };
      if (config.password != null) {
        options['auth_pass'] = config.password;
      }
      Database.connection = redis.createClient(config.port, config.host, options);
      Database.config = config;
      Database.connection.debug_mode = Environment.debug;
      Database.connection.on('ready', function() {
        return logger.info("Remote redis store version '" + Database.connection.server_info.redis_version + "' is up and running on '" + Database.connection.server_info.os + "' OS.");
      });
      Database.connection.on('connect', function() {
        Database.connected = true;
        logger.info("Connection to redis store at " + Database.url + " established");
        if (config.database != null) {
          logger.info("Changing redis db to " + config.database + " ...");
          return Database.connection.select(config.database, function(err, response) {
            if (err) {
              logger.error("Failed to change db to " + config.database + " due to errror. Falling back to db 0.", {
                error: err.toString()
              });
            }
            return this.after_connect();
          });
        } else {
          logger.info("Connected to redis db 0");
          return Database.after_connect();
        }
      });
      Database.connection.on('end', function() {
        Database.connected = false;
        logger.warn("Connection to redis store at " + Database.url + " closed.");
        return Database.after_disconnect();
      });
      Database.connection.on('error', function(err) {
        if (err) {
          return logger.error("Error occurred during redis operation", {
            error: err.toString()
          });
        }
      });
      return Database.connection.on('drain', function() {
        return logger.info("TCP connection to redis store at " + Database.url + " is now writable again.");
      });
    };

    Database.close = function(callback) {
      if (!Database.connected) {
        return;
      }
      logger.info("Closing connection to redis store at " + Database.url + " ...");
      return Database.connection.quit();
    };

    Database.drop = function(callback) {
      assert(Database.connected, "Connection to the redis store not established.");
      logger.warn("Dropping current db " + (Database.current_db()) + " at " + Database.url);
      return Database.connection.flushdb(function(err, response) {
        if (err) {
          logger.error("Could not drop current db " + (Database.current_db()) + " due to error", {
            error: err.toString()
          });
        }
        if (callback) {
          return callback(err);
        }
      });
    };

    Database.drop_all = function(callback) {
      assert(Database.connected, "Connection to the redis store not established");
      logger.warn("Droping all databases at " + Database.url + ".");
      return Database.connection.flushall(function(err, response) {
        if (err) {
          logger.error("Could not drop all database due to error", {
            error: err.toString()
          });
        }
        if (callback) {
          return callback(err);
        }
      });
    };

    return Database;

  }).call(this, Module);

  module.exports = Database;

}).call(this);
