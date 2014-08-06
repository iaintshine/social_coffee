Server      = require '../lib/server'
Database    = require '../lib/db'

SeedGenerator = require './support/seed'

global.server = new Server 

post_lift = (done) ->
    (connection) ->
        SeedGenerator.seed()
        done()

before (done) ->
    options = 
        port: 0

    Database.on 'connect', post_lift(done)
    server.start options
    
after (done) ->
    # This method behaves as database cleaner
    Database.drop()
    done()