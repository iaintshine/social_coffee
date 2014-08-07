Thrift = require './thrift/client'
SocialCoffee = require './version'

readline  = require 'readline'
Commander = require 'commander'

class Completer

    COMPLETIONS = 
        friends: ['list']
        friendship: ['create', 'remove']
        quit: []
    
    complete: (line) ->
        commands = line.trim().split /\s+/i
        
        if commands.length == 2
            if COMPLETIONS[commands[0]]
                hits = COMPLETIONS[commands[0]].filter (c) -> c.indexOf(commands[1]) == 0
                suggestions = if hits.length > 0 then hits else COMPLETIONS[commands[0]]
            else 
                suggestions = []
            line_part = commands[1] 
        else if commands.length == 1 and line[line.length - 1] == ' '
            suggestions = if COMPLETIONS[commands[0]] then COMPLETIONS[commands[0]] else []
            line_part = commands[0]
        else if commands.length == 1
            hits = Object.keys(COMPLETIONS).filter (c) -> c.indexOf(commands[0]) == 0
            suggestions = if hits.length > 0 then hits else Object.keys(COMPLETIONS)
            line_part = commands[0]

        [suggestions, line_part]

class CLI
    constructor: ->
        @completer = new Completer

    handle_friends: (commands) ->
        console.log commands

    handle_friendship: (commands) ->
        console.log commands

    handle_quit: ->
        console.log "bye bye ..."
        @cmd_interface.close()

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
            completer: @completer.complete

        @cmd_interface = readline.createInterface cmd_options

        # -- Set the prompt --

        prompt = "#{options.host}:#{options.port}>"
        @cmd_interface.setPrompt prompt, prompt.length

        @cmd_interface.on 'line', (line) =>
            commands = line.trim().split /\s+/i

            switch commands[0]
                when "friends"
                    @handle_friends commands
                when "friendship"
                    @handle_friendship commands
                when "quit"
                    @handle_quit()
                else
                    console.log 'command unknown' if line.trim().length > 0 

            @cmd_interface.prompt()

        @cmd_interface.on 'close', ->
            process.exit 0

        # -- Wait for user input -- 

        @cmd_interface.prompt()

module.exports = CLI