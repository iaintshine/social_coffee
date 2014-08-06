Database = require '../../lib/db'
Friendship = require '../../lib/friendship'

describe 'Friendship', ->
    user_a = 1
    user_b = 2

    describe '#create', ->

        describe 'invalid calls', ->
            it 'returns TypeError if argument is undefined', (done) ->
                Friendship.create null, null, (error, created) ->
                    error.should.be.ok
                    error.should.be.instanceof TypeError
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns TypeError if argument is not a number', (done) ->
                Friendship.create "1", 1, (error, created) ->
                    error.should.be.ok
                    error.should.be.instanceof TypeError
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns RangeErorr if argument has non positive value', (done) ->
                Friendship.create -1, 1, (error, created) ->
                    error.should.be.ok
                    error.should.be.instanceof RangeError
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

            it 'returns error if both arguments are equal', (done) ->
                Friendship.create 1, 1, (error, created) ->
                    error.should.be.ok
                    error.should.be.instanceof Error 
                    error.message.should.equal 'function arguments must not be equal'
                    done()

        describe 'users are not friends', ->
            beforeEach (done) ->
                Database.drop (error) ->
                    done(error)    

            it 'shouldnt return any error', (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    (error is null).should.be.true
                    done()

            it 'should add second user to users friends circle', (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    Friendship.select user_a, (error, friends) ->
                        friends.should.containEql user_b
                        done()

            it 'should create mutual relationship', (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    Friendship.select user_b, (error, friends) ->
                        friends.should.containEql user_a
                        done()

            it 'should set created (second argument) to true', (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    created.should.be.true
                    done()

        describe 'users are already friends', ->
            before (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    done(error)

            after (done) ->
                Database.drop (error) ->
                    done(error)

            it 'shouldnt return any error', (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    (error is null).should.be.true
                    done()

            it 'should set created (second argument) to false', (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    created.should.be.false
                    done()


    describe '#remove', ->

        describe 'invalid calls', ->
            it 'returns TypeError if argument is undefined', (done) ->
                Friendship.remove null, null, (error, removed) ->
                    error.should.be.ok
                    error.should.be.instanceof TypeError
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns TypeError if argument is not a number', (done) ->
                Friendship.remove "1", 1, (error, removed) ->
                    error.should.be.ok
                    error.should.be.instanceof TypeError
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns RangeErorr if argument has non positive value', (done) ->
                Friendship.remove -1, 1, (error, removed) ->
                    error.should.be.ok
                    error.should.be.instanceof RangeError
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

            it 'returns error if both arguments are equal', (done) ->
                Friendship.remove 1, 1, (error, removed) ->
                    error.should.be.ok
                    error.should.be.instanceof Error 
                    error.message.should.equal 'function arguments must not be equal'
                    done()

        describe 'users are already friends', ->
            beforeEach (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    done(error)

            it 'shouldnt return any error', (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    (error is null).should.be.true
                    done()

            it 'should remove second user from users friends circle', (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    Friendship.select user_a, (error, friends) ->
                        friends.should.not.containEql user_b
                        done()

            it 'should remove mutual relationship', (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    Friendship.select user_b, (error, friends) ->
                        friends.should.not.containEql user_a
                        done()

            it 'should set removed (second argument) to true', (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    removed.should.be.true
                    done()

        describe 'users are not friends', ->
            # make sure there are no relationship in database
            before (done) ->
                Database.drop (error) ->
                    done(error)

            it 'shouldnt return any error', (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    (error is null).should.be.true
                    done()

            it 'should set removed (second argument) to false', (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    removed.should.be.false
                    done()

    describe '#select', ->

        describe 'invalid calls', ->
             it 'returns TypeError if argument is undefined', (done) ->
                Friendship.select null, (error, friends) ->
                    error.should.be.ok
                    error.should.be.instanceof TypeError
                    error.message.should.equal 'function argument must not be null'
                    done()

            it 'returns TypeError if argument is not a number', (done) ->
                Friendship.select "1", (error, friends) ->
                    error.should.be.ok
                    error.should.be.instanceof TypeError
                    error.message.should.equal 'function argument is not a number'
                    done()

            it 'returns RangeErorr if argument has non positive value', (done) ->
                Friendship.select -1, (error, friends) ->
                    error.should.be.ok
                    error.should.be.instanceof RangeError
                    error.message.should.equal 'function argumenst is not a positive number'
                    done()

        describe 'user without friend relationships', ->
            it 'shouldnt return any error', (done) ->
                Friendship.select user_a, (error, friends) ->
                    (error is null).should.be.true
                    done()

            it 'should return empty array', (done) ->
                Friendship.select user_a, (error, friends) ->
                    friends.should.be.instanceof Array
                    friends.should.be.empty
                    done()

        describe 'user with friends', (done) ->
            before (done) ->
                Friendship.create user_a, user_b, (error, created) ->
                    done(error)

            after (done) ->
                Friendship.remove user_a, user_b, (error, removed) ->
                    done(error)

            it 'shouldnt return any error', (done) ->
                Friendship.select user_a, (error, friends) ->
                    (error is null).should.be.true
                    done()

            it 'should return an array with friend ids', (done) ->
                Friendship.select user_a, (error, friends) ->
                    friends.should.be.instanceof Array
                    friends.should.not.be.empty
                    friends.should.eql [user_b]
                    done()