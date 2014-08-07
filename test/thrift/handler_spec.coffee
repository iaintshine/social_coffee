Database    = require '../../lib/db'
Friendship  = require '../../lib/friendship'
Thrift      = require '../../lib/thrift/handler'
ttypes      = require '../../lib/thrift/social_coffee_service_types'

describe 'Trhfit.Handler', ->
    user_a = 1
    user_b = 2

    describe '#ping', ->
        it 'should return pong string', (done) ->
            Thrift.Handler.ping (error, result) ->
                result.should.equal "pong"
                done()

    describe '#get_friends', ->

        describe 'invalid calls', ->
             it 'returns SocialException if argument is undefined', (done) ->
                Thrift.Handler.get_friends null, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns SocialException if argument is not a number', (done) ->
                Thrift.Handler.get_friends "1", (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns SocialException if argument has non positive value', (done) ->
                Thrift.Handler.get_friends -1, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

        describe 'user without friend relationships', ->
            it 'should return empty array', (done) ->
                Thrift.Handler.get_friends user_a, (error, result) ->
                    result.should.be.instanceof Array
                    result.should.be.empty
                    done()

        describe 'user with friends', (done) ->
            before (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    done(error)

            after (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    done(error)

            it 'should return an array with friend ids', (done) ->
                Thrift.Handler.get_friends user_a, (error, result) ->
                    result.should.be.instanceof Array
                    result.should.not.be.empty
                    result.should.eql [user_b]
                    done()


    describe '#create_friendship', ->
        
        describe 'invalid calls', ->
            it 'returns SocialException if first argument is undefined', (done) ->
                Thrift.Handler.create_friendship null, user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns SocialException if second argument id undefined', (done) ->
                Thrift.Handler.create_friendship user_a, null, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns SocialException if first argument is not a number', (done) ->
                Thrift.Handler.create_friendship "notanumber", user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns SocialException if second argument is not a number', (done) ->
                Thrift.Handler.create_friendship user_a, "notanumber", (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns SocialException if first argument has non positive value', (done) ->
                Thrift.Handler.create_friendship -user_a, user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

            it 'returns SocialException if second argument has non positive value', (done) ->
                Thrift.Handler.create_friendship user_a, -user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

            it 'returns SocialException if both arguments are equal', (done) ->
                Thrift.Handler.create_friendship user_a, user_a, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException 
                    error.message.should.equal 'function arguments must not be equal'
                    done()

        describe 'users are not friends', ->
            beforeEach (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    done(error)    

            it 'should add second user to users friends circle', (done) ->
                Thrift.Handler.create_friendship user_a, user_b, (error, result) ->
                    Friendship.select user_a, (error, friends) ->
                        friends.should.containEql user_b
                        done()

            it 'should create mutual relationship', (done) ->
                Thrift.Handler.create_friendship user_a, user_b, (error, result) ->
                    Friendship.select user_b, (error, friends) ->
                        friends.should.containEql user_a
                        done()

            it 'should return true', (done) ->
                Thrift.Handler.create_friendship user_a, user_b, (error, result) ->
                    result.should.be.true
                    done()

        describe 'users are already friends', ->
            before (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    done(error)

            after (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    done(error)

            it 'should return false', (done) ->
                Thrift.Handler.create_friendship user_a, user_b, (error, result) ->
                    result.should.be.false
                    done()


    describe '#remove_friendship', ->  

        describe 'invalid calls', ->
            it 'returns SocialException if first argument is undefined', (done) ->
                Thrift.Handler.remove_friendship null, user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns SocialException if second argument id undefined', (done) ->
                Thrift.Handler.remove_friendship user_a, null, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns SocialException if first argument is not a number', (done) ->
                Thrift.Handler.remove_friendship "notanumber", user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns SocialException if second argument is not a number', (done) ->
                Thrift.Handler.remove_friendship user_a, "notanumber", (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns SocialException if first argument has non positive value', (done) ->
                Thrift.Handler.remove_friendship -user_a, user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

            it 'returns SocialException if second argument has non positive value', (done) ->
                Thrift.Handler.remove_friendship user_a, -user_b, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

            it 'returns SocialException if both arguments are equal', (done) ->
                Thrift.Handler.remove_friendship user_a, user_a, (error, result) ->
                    error.should.be.ok
                    error.should.be.instanceof ttypes.SocialException 
                    error.message.should.equal 'function arguments must not be equal'
                    done()

        describe 'users are already friends', ->
            beforeEach (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    done(error)

            it 'should remove second user from users friends circle', (done) ->
                Thrift.Handler.remove_friendship user_a, user_b, (error, result) ->
                    Friendship.select user_a, (error, friends) ->
                        friends.should.not.containEql user_b
                        done()

            it 'should remove mutual relationship', (done) ->
                Thrift.Handler.remove_friendship user_a, user_b, (error, result) ->
                    Friendship.select user_b, (error, friends) ->
                        friends.should.not.containEql user_a
                        done()

            it 'should return true', (done) ->
                Thrift.Handler.remove_friendship user_a, user_b, (error, result) ->
                    result.should.be.true
                    done()

        describe 'users are not friends', ->
            it 'should return false', (done) ->
                Thrift.Handler.remove_friendship user_a, user_b, (error, result) ->
                    result.should.be.false
                    done()