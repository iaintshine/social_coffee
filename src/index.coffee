SocialCoffee = require './version'
Server       = require './server'

Commander = require 'commander'

# -- Parse command line arguments --

Commander
    .version("Social Coffee v#{SocialCoffee.version} '#{SocialCoffee.codename}'")
    .option('-p, --port <n>', 'Port number', parseInt)
    .parse(process.argv)

# -- Configure run --

options = {}
options['port'] = Commander.port || 3000

# -- Run the service --

server = new Server
server.start options
