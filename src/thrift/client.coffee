ttypes      = require './social_coffee_service_types'
Processor   = require './SocialCoffeeService'

assert  = require 'assert'

thrift  = require 'node-thrift'
logger  = require 'winston'

class SocialCoffee.Thrift.Client
    
    @connect: (host, port) ->
        assert host and typeof host == 'string', 'host parameter is invalid or missing'
        assert port and typeof port == 'number', 'port number is invalid or missing'

        thrift_options = 
            transport: thrift.TFramedTransport
            protocol: thrift.TBinaryProtocol
            debug: true
            max_attempts: 2         # retry max attempts
            connect_timeout: 2000   # 2s

        @connection = thrift.createConnection host, port, thrift_options

        @connection.on 'error', (error) ->
            logger.error "Error occurred during commmunication with thrift server", error: error.toString()

        @client = thrift.createClient Processor, @connection

        @client


exports.Client = SocialCoffee.Thrift.Client