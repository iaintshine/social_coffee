SocialCoffee= require '../../lib/version'
Thrift      = require '../../lib/thrift/handler'

# We use Thrift.Handler during tests since it extends FacebookBase

describe 'FacebookBase', ->
    
    describe '#getVersion', ->
        it 'should return current service version', (done) ->
            Thrift.Handler.getVersion (error, result) ->
                result.should.equal SocialCoffee.version
                done()