Environment = require './environment'

assert = require 'assert'

logger = require 'winston'
redis  = require 'redis'


class Database
    @connected  = false
    @connection = null
    @config     = null
    @url        = null

    @current_db: => if @config? and @config.database? then @config.database else 0

    @check_config: (config) ->
        assert config, "This function requires config"
        assert config.host and typeof config.host == 'string', "host configuration is invalid or missing"
        assert config.port and typeof config.port == 'number' and config.port >= 0, "port configuration is invalid or missing"
        if config.database?
            assert typeof config.database == 'number', "Redis database index must be a number"
            assert config.database >= 0, "Redis database index must be greater than or equal to 0" 

        if config.password?
            assert typeof config.password == 'string', "Redis auth password must be a string"
            assert config.password.length > 0, "Redis auth password must be of length greater than 0"

    @connect: (config, callback) =>
        return if @connected

        @check_config config

        @url = "tcp://#{config.host}:#{config.port}"
        logger.info "Connecting to redis instance at #{@url} ..."

        options = 
            parser: 'hiredis'

        options['auth_pass'] = config.password if config.password?

        @connection = redis.createClient config.port, config.host, options
        @config     = config

        @connection.on 'connect', =>
            @connected = true

            logger.info "Connection to redis store at #{@url} established"
            if config.database?
                logger.info "Changing redis db to #{config.database} ..."
                @connection.select config.database, (err, response) ->
                    logger.error "Failed to change db to #{config.database} due to errror. Falling back to db 0.", error: err.toString() if err 
                    callback @connnection
            else
                logger.info "Connected to redis db 0"
                callback @connection

        @connection.on 'end', =>
            @connected = false
            logger.warn "Connection to redis store at #{@url} closed."

        @connection.on 'error', (err) ->
            logger.error "Error occurred during redis operation", error: err.toString()

        @connection.on 'drain', =>
            logger.info "TCP connection to redis store at #{@url} is now writable again."


    @close: (callback) =>
        return unless @connected

        logger.info "Closing connection to redis store at #{@url} ..."
        @connection.quit()

    @drop: (callback) =>
        assert @connected, "Connection to the redis store not established."
        logger.warn "Dropping current db #{@current_db()} at #{@url}"

        @connection.flushdb (err, response) ->
            logger.error "Could not drop current db #{@current_db()} due to error", error: err.toString()
            callback err

    @drop_all: (callback) =>
        assert @connected, "Connection to the redis store not established"
        logger.warn "Droping all databases at #{@url}."

        @connection.flushall (err, response) ->
            logger.error "Could not drop all database due to error", error: err.toString()
            callback err

module.exports = Database
