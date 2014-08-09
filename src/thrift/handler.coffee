ttypes      = require './social_coffee_service_types'
FacebookBase= require './facebook_base_handler'
Friendship  = require '../friendship' 

class SocialCoffee.Thrift.Handler extends FacebookBase
    
    # -- Thrift helpers --

    @failure: (error, result) ->
        ex = new ttypes.SocialException()
        ex.message = error.message

        result ex

    @success: (value, result) ->
        result null, value

    # -- Handler implementation --

    @ping: (result) =>
        result(null, "pong")

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

exports.Handler = SocialCoffee.Thrift.Handler 