ttypes      = require './social_coffee_service_types'
Friendship  = require '../friendship' 

class Thrift.Handler

    # -- Thrift helpers --

    @failure: (error, result) ->
        result new ttypes.SocialException(error.message)

    @success: (value, result) ->
        result null, value


class SocialCoffee.Thrift.Handler extends Thrift.Handler
    
    # -- Handler implementation --

    @get_friends: (id, result) =>
        Friendship.select id, (error, friends) =>
            if error
                @failure error, result
            else
                @success friends, result


    @create_friendship: (usera, userb, result) =>
        Friendship.create usera, userb, (error, created) =>
            if error
                @failure error, result
            else
                @success created, result

    @remove_friendship: (usera, userb, result) =>
        Friendship.remove usera, userb, (error, removed) =>
            if error
                @failure error, result
            else
                @success removed, result

module.exports.Handler = SocialCoffee.Thrift.Handler 