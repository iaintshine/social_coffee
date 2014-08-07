Thrift = require './thrift/client'
SocialCoffee = require './version'

readline  = require 'readline'
Commander = require 'commander'

class CLI
    completer: (line) ->
        null

    start: (args) ->
 
        # -- Parse command line arguments --
        
        Commander
            .version("Social Coffee v#{SocialCoffee.version} '#{SocialCoffee.codename}'")
            .option('-p, --port <n>', 'Port number', parseInt)
            .option('-h, --host [host]', 'Host number', 'localhost')
            .parse(args)

        # -- Configure run --

        options = {}
        options['host'] = Commander.host || 'localhost'
        options['port'] = Commander.port || 9090

        # -- Connect to thrift server --

        @client = Thrift.Client.connect options.host, options.port

        # -- Create readline interface instance -- 

        cmd_options = 
            input: process.stdin
            output: process.stdout
            completer: @completer

        @cmd_interface = readline.createInterface cmd_options

        # -- Set the prompt --

        prompt = "#{options.host}:#{options.port}>"
        @cmd_interface.setPrompt prompt, prompt.length

        @cmd_interface.on 'line', (line) ->

        @cmd_interface.on 'close', ->
            process.exit 0

        # -- Wait for user input -- 

        @cmd_interface.prompt()

module.exports = CLI