Environment = require './environment'
KnownPath   = require './known_path'

path = require 'path'
fs   = require 'fs'

logger = require 'winston'

class Logger
    @output_path: ->
        file_name = "#{Environment.env}.log"
        path.join KnownPath.log, file_name

    @prepare_fs: ->
        fs.mkdirSync(KnownPath.log) unless fs.existsSync(KnownPath.log)

    @say_hi: ->
        @info "You are running in #{Environment.env} environment"

    @initialize: ->
        @prepare_fs()
        logger.clear()
        logger.add logger.transports.Console, colorize: true, label: process.pid unless Environment.production
        options = 
            filename: @output_path()
            json: false
            timestamp: false
            label: process.pid
        logger.add logger.transports.File, options

        @say_hi()

module.exports = Logger