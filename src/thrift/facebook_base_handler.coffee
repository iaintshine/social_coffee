SocialCoffee = require '../version' 

ttypes = require './fb303_types'

logger = require 'winston'

# -- Handler implementation --

class FacebookBase

    # -- Shard variables --

    @counters = {}
    @options  = {}
    @alive    = Date.now()
    @name     = "SocialCoffee - v#{SocialCoffee.version} (#{SocialCoffee.codename})"

    # -- Standard service information --

    @getName: (result) ->
        result null, @name

    @getVersion: (result) ->
        result null, SocialCoffee.version

    @getStatus: (result) ->
        result null, ttypes.fb_status.ALIVE

    @getStatusDetails: (result) ->
        result null, "service is up and running"

    @aliveSince: (result) ->
        result null, @alive

    # -- Performance counters --

    @getCounters: (result) ->
        result null, @counters

    @getCounter: (key, result) ->
        result null, (if @counters[key]? then @counters[key] else 0)

    @getCpuProfile: (profileDurationInSec, result) ->
        result null, ""

    # -- Service options --

    @setOption: (key, value, result) ->
        @options[key] = value
        result null

    @getOption: (key, result) ->
        result null, (if @options[key]? then @options[key] else "")

    @getOptions: (result) ->
        result null, @options

    # -- System control --

    @reinitialize: ->
        logger.warn "Reinitialization request just came. Skipping ..."

    @shutdown: ->
        logger.warn "Shutdown request just came. Skipping ..."

module.exports = FacebookBase