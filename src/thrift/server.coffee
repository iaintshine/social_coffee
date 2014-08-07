ttypes      = require './social_coffee_service_types'
Processor   = require './SocialCoffeeService'
Handler     = require './handler'

thrift  = require 'thrift'
logger  = require 'winston'

class Thrift.Server

    constructor: ->
        @server = null

    start: (options, callback) ->
        assert options, "This function call requires options"
        assert options.port and typeof port == 'number' and port >= 0, "port value is invalid or missing"

        thrift_options = 
            transport: thrift.TFramedTransport
            protocol: thrift.TBinaryProtocol

        @server = thrift.createServer Processor, Handler, thrift_options

        @server.on 'listening', ->
            logger.info "Social Coffee Thrift server socket has been bound"

        @server.on 'connection', (socket) ->
            logger.info "New client connection accepted from #{socket.remoteAddress}:#{socket.remotePort}"

        @server.on 'close', ->
            logger.warn "Social Coffee Thfit server has been closed."

        @server.on 'error', (error) ->
            logger.error "Error occurred during thrift server operation", error: err.toString()

        @server.listen options.port, ->
            logger.info "Social Coffee Thrift server is listening at port #{options.port}"
            callback() if callback? and typeof callback == 'function'

    stop: (callback) ->
        if @server?
            logger.info "Closing Social Coffee Thrift server ..."
            @server.close ->
                logger.info "Social Coffee thrift server is closed. No more connections will be accepted."
                callback() if callback? and typeof callback == 'function'
                @server = null