SocialCoffee= require '../../lib/version'
Thrift      = require '../../lib/thrift/handler'
FacebookBase= require '../../lib/thrift/facebook_base_handler'
ttypes      = require '../../lib/thrift/fb303_types'

# We use Thrift.Handler during tests since it extends FacebookBase

describe 'FacebookBase', ->
    
    describe '#getName', ->
        it 'should return services name, version and codename', (done) ->
            Thrift.Handler.getName (error, result) ->
                result.should.equal "SocialCoffee - v#{SocialCoffee.version} (#{SocialCoffee.codename})"
                done()

    describe '#getVersion', ->
        it 'should return current service version', (done) ->
            Thrift.Handler.getVersion (error, result) ->
                result.should.equal SocialCoffee.version
                done()

    describe '#getStatus', ->
        it 'should return ALIVE', (done) ->
            Thrift.Handler.getStatus (error, result) ->
                result.should.equal ttypes.fb_status.ALIVE
                done()

    describe '#getStatusDetails', ->
        it 'should return ALIVE description', (done) ->
            Thrift.Handler.getStatusDetails (erorr, result) ->
                result.should.equal "ALIVE - service is up and running"
                done()

    describe '#aliveSince', ->
        it 'should return positive value less than current timestamp', (done) ->
            Thrift.Handler.aliveSince (error, result) ->
                result.should.be.greaterThan(0).and.lessThan(Date.now())
                done()

    describe '#getCounters', ->
        it 'should return facebook base counters object', (done) ->
            Thrift.Handler.getCounters (error, result) ->
                result.should.equal FacebookBase.counters
                done()

    describe '#getCounter', ->
        describe 'counter doesnt exist', ->
            it 'should return 0', (done) ->
                Thrift.Handler.getCounter 'request_per_sec', (error, result) ->
                    result.should.equal 0
                    done()

        describe 'counter exists', ->
            counter = 'mem_usage'
            value   = 100 * 1024 * 1024

            before ->
                FacebookBase.counters[counter] = value
            
            after ->
                delete FacebookBase.counters[counter]

            it 'should return counter value', (done) ->
                Thrift.Handler.getCounter counter, (error, result) ->
                    result.should.equal value
                    done()

    describe '#resetCounter', (done) ->
        counter = 'mem_usage'
        value   = 100 * 1024 * 1024

        before ->
            FacebookBase.counters[counter] = value

        after ->
            delete FacebookBase.counters[counter]

        it 'should set counter to 0', (done) ->
            Thrift.Handler.resetCounter counter
            FacebookBase.counters[counter].should.equal 0
            done()

    describe '#incrementCounter', ->
        counter = 'mem_usage'
        value   = 100 * 1024 * 1024

        describe 'counter doesnt exist', ->
            it 'should create counter and set its value to 1', (done) ->
                Thrift.Handler.incrementCounter counter
                FacebookBase.counters[counter].should.be.ok
                FacebookBase.counters[counter].should.equal 1
                done()

        describe 'counter exists', ->
            before ->
                FacebookBase.counters[counter] = value

            after ->
                delete FacebookBase.counters[counter]

            it 'should increment current value by 1', (done) ->
                Thrift.Handler.incrementCounter counter
                FacebookBase.counters[counter].should.be.ok
                FacebookBase.counters[counter].should.equal(value + 1)
                done() 

    describe '#deleteCounter', ->
        counter = 'mem_usage'
        value   = 100 * 1024 * 1024

        it 'should remove counter', (done) ->
            FacebookBase.counters[counter] = value
            Thrift.Handler.deleteCounter counter
            (FacebookBase.counters[counter]?).should.be.false
            done()

    describe '#getCpuProfile', ->
        it 'should return empty string - not implemented', (done) ->
            Thrift.Handler.getCpuProfile 0, (error, result) ->
                result.should.equal ""
                done()

    describe '#setOption', ->
        it 'should store its value at FacebookBase options object', (done) ->
            Thrift.Handler.setOption 'FOO', 'BAR', (error, result) ->
                FacebookBase.options['FOO'].should.equal 'BAR'
                delete FacebookBase.options['FOO']
                done()

    describe '#getOption', ->
        describe 'option doesnt exist', ->
            it 'should return an empty string', (done) ->
                Thrift.Handler.getOption 'FOO', (error, result) ->
                    result.should.equal ''
                    done()

        describe 'option exists', ->
            before ->
                FacebookBase.options['FOO'] = 'BAR'

            after ->
                delete FacebookBase.options['FOO']

            it 'should return options value', (done) ->
                Thrift.Handler.getOption 'FOO', (error, result) ->
                    result.should.equal 'BAR'
                    done()

    describe '#getOptions', ->
        it 'should return FacebookBase options object', (done) ->
            Thrift.Handler.getOptions (error, result) ->
                result.should.equal FacebookBase.options
                done()
