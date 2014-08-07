fs     = require 'fs'
path   = require 'path'
logger = require 'winston'
assert = require 'assert'

SocialCoffee= require './version'
Environment = require './environment' 
KnownPath   = require './known_path'
Logger      = require './logger'
Config      = require './config'
Database    = require './db'
Thrift      = require './thrift/server'

class Server

    constructor: ->
        @stop     = false
        @pid_path = path.join KnownPath.pids, 'server.pid'

        logger.info "Server instance has just been constructed"

    # -- OS related --

    # `server.pid` file is stored under tmp/pids directory
    store_pid: ->
        fs.mkdirSync(KnownPath.tmp) unless fs.existsSync(KnownPath.tmp)
        fs.mkdirSync(KnownPath.pids) unless fs.existsSync(KnownPath.pids)
        
        fs.writeFileSync @pid_path, process.pid

    remove_pid: -> 
        fs.unlinkSync(@pid_path) if fs.existsSync(@pid_path)

    register_signal_handler: ->
        process.on 'SIGTERM', =>
            @stop()

        process.on 'SIGINT', =>
            @stop()

        process.on 'exit', (code) ->
            logger.info "Exiting #{if code != 0 then "abnormally" else "normally"} with code #{code}"

    # -- Main entry point --

    start: (options) ->
        assert options, "This function requires options"
        assert options.port? and typeof options.port == 'number' and options.port >= 0, "port configuration is invalid or missing"
        
        # -- Introduce --

        logger.info "Social Coffee v#{SocialCoffee.version} '#{SocialCoffee.codename}' orchestrating the show"

        # -- Pre Configure --

        Logger.initialize()
        Config.initialize()

        # -- Database --

        Database.connect Config.db

        # -- We are up and running --

        @store_pid()
        logger.info "Process PID #{process.pid} stored in #{@pid_path}"

        # -- Start thrift server --
        @thrift_server = new Thrift.Server
        @thrift_server.start options, ->
            logger.info "All things are set up!"

    stop: ->
        @thrift_server.stop =>
            logger.info "We are shutting down!"

            Database.close()

            @remove_pid()


module.exports = Server