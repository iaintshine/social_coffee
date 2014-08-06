Database = require './db'

logger   = require 'winston'

class Friendship

    # -- Helpers --

    @connect: -> Database.connection

    @key: (id) -> "user:#{id}:friends"

    @sanitize_argument: (arg) ->
        return new TypeError "function argument must not be null" unless arg?
        return new TypeError "function argument is not a number" unless typeof arg == 'number'
        return new RangeError "function argumenst is not a positive number" if arg < 0
        return null          

    # -- Insert/update/remove --

    @create: (usera, userb, callback) =>
        error = @sanitize_argument usera
        if error
            callback error if callback
            return 

        error = @sanitize_argument userb
        if error 
            callback error if callback
            return

        @connect().multi()
            .sadd(@key(usera), userb)
            .sadd(@key(userb), usera)
            .exec (err, replies) ->
                if err? and err.length > 0
                    logger.error "Friendship#create failed with some errors", errors: err.toString()
                    callback err[0] if callback
                    return

                if callback
                    created = replies and replies[0] > 0
                    callback null, created


    @remove: (usera, userb, callback) ->
        error = @sanitize_argument usera
        if error
            callback error if callback
            return 

        error = @sanitize_argument userb
        if error 
            callback error if callback
            return

        @connect().multi()
            .srem(@key(usera), userb)
            .srem(@key(userb), usera)
            .exec (err, replies) ->
                if err? and err.length > 0
                    logger.error "Friendship#remove failed with some errors", errors: err.toString()
                    callback err[0] if callback
                    return

                if callback
                    removed = replies and replies[0] > 0
                    callback null, removed
    
    # -- Finders --

    @select: (user, callback) -> 
        error = @sanitize_argument usera
        if error
            callback error if callback
            return 
        
        return unless callback 

        @connect().smembers @key(user), (err, values) ->
            if err 
                logger.error "Friendship#select failed due to error", error: err.toString()
                callback err
            else 
                callback null, values

module.exports = Friendship