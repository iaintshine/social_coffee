
describe 'Friendship', ->
    describe '#create', ->

        describe 'invalid calls', ->
            it 'returns TypeError if argument is undefined', (done) ->
                Friendship.create null, null, (error) ->

            it 'returns TypeError if argument is not a number', (done) ->

            it 'returns RangeErorr if argument has non positive value', (done) ->

            it 'returns error if both arguments are equal', (done) ->

        describe 'users are not friends', ->
            it 'shouldnt return any error', (done) ->

            it 'should create mutual relationship', (done) ->

            it 'should set created (second argument) to true', (done) ->

        describe 'users are already friends', ->
            it 'shouldnt return any error', (done) ->

            it 'should be idempotent', (done) -> 

            it 'should set created (second argument) to false', (done) ->

    describe '#remove', ->

        describe 'invalid calls', ->
            it 'returns TypeError if argument is undefined', (done) ->

            it 'returns TypeError if argument is not a number', (done) ->

            it 'returns RangeErorr if argument has non positive value', (done) ->

            it 'returns error if both arguments are equal', (done) ->

        describe 'users are already friends', ->
            it 'shouldnt return any error', (done) ->

            it 'should remove mutual relationship', (done) ->

            it 'should set removed (second argument) to true', (done) ->


        describe 'users are not friends'
            it 'shouldnt return any error', (done) ->

            it 'should be idempontent', (done) ->

            it 'should set removed (second argument) to false', (done) ->
                

    describe '#select', ->

        describe 'invalid calls', ->
            it 'returns TypeError if argument is undefined', (done) ->

            it 'returns TypeErorr if argument is not a number', (done) ->

            it 'returns RangeErorr if arguments has non positive value', (done) ->


        describe 'user without friend relationships', ->
            it 'shouldnt return any error', (done) ->

            it 'should return empty array', (done) ->

        describe 'user with friends', (done) ->
            it 'shouldnt return any error', (done) ->

            it 'should return an array with friend ids', (done) ->