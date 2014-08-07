Thrift = require './thrift/client'
SocialCoffee = require './version'

readline  = require 'readline'
Commander = require 'commander'

class Completer

    COMPLETIONS = 
        friends: ['list']
        friendship: ['create', 'remove']
        quit: []
        ping: []
    
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

class Command
    constructor: (context) ->
        @context = context

    prompt: -> @context.prompt()

    execute: (commands) ->
        console.log commands 


class QuitCommand extends Command 

    execute: (commands) ->
        console.log "bye bye ..."
        @context.close()

class PingCommand extends Command 

    execute: (commands) ->
        Thrift.Client.client.ping (err, result) =>
            if err
                console.log "error occurred: " + err.message 
            else
                console.log result
            @prompt()

class ListFriendsCommand extends Command

    execute: (commands) ->
        if commands.length == 3
            id = parseInt commands[2]

            if isNaN(id) 
                console.log "error occurred: argument must be a positive number"
                return @prompt()

            Thrift.Client.client.get_friends id, (err, friends) =>
                if err
                    console.log "error occurred: " + err.message
                else
                    console.log friends
                @prompt()

class CreateFriendshipCommand extends Command 

    execute: (commands) ->
        if commands.length == 4
            usera = parseInt commands[2]
            userb = parseInt commands[3]

            if isNaN(usera) or isNaN(userb)
                console.log "error occurred: both of arguments must be positive numbers"
                return @prompt()

            Thrift.Client.client.create_friendship usera, userb, (err, created) =>
                if err
                    console.log "error occurred: " + err.message
                else
                    console.log "friendship newely created: " + created
                @prompt()

class RemoveFriendshipCommand extends Command 

    execute: (commands) ->
        if commands.length == 4
            usera = parseInt commands[2]
            userb = parseInt commands[3]

            if isNaN(usera) or isNaN(userb)
                console.log "error occurred: both of arguments must be positive numbers"
                return @prompt()

            Thrift.Client.client.remove_friendship usera, userb, (err, removed) =>
                if err
                    console.log "error occurred: " + err.message
                else
                    console.log "friendship just removed: " + removed
                @prompt()

class CLI
    constructor: ->
        @completer = new Completer

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

        # -- Create readline interface instance -- 

        cmd_options = 
            input: process.stdin
            output: process.stdout
            completer: @completer.complete

        @cmd_interface = readline.createInterface cmd_options

        # -- Set the prompt --

        prompt = "#{options.host}:#{options.port}>"
        @cmd_interface.setPrompt prompt, prompt.length

        @cmd_interface.on 'SIGINT', =>
            @cmd_interface.question 'Are you sure you want to exit? [yes|no] ', (answer) =>
                new QuitCommand(@cmd_interface).execute() if answer.match /^y(es)?$/i
                @cmd_interface.prompt()

        @cmd_interface.on 'line', (line) =>
            commands = line.trim().split /\s+/i

            switch commands[0]
                when "friends"
                    if commands.length > 1 and commands[1] == 'list' 
                        new ListFriendsCommand(@cmd_interface).execute commands

                when "friendship"
                    if commands.length > 1
                        switch commands[1]
                            when 'create' then new CreateFriendshipCommand(@cmd_interface).execute commands 
                            when 'remove' then new RemoveFriendshipCommand(@cmd_interface).execute commands
                when "ping"
                    new PingCommand(@cmd_interface).execute commands
                when "quit"
                    new QuitCommand(@cmd_interface).execute commands
                else
                    console.log 'command unknown' if line.trim().length > 0 
                    @cmd_interface.prompt()

        @cmd_interface.on 'close', =>
            Thrift.Client.close()
            process.exit 0

         # -- Connect to thrift server --

        Thrift.Client.connect options.host, options.port, =>
            @cmd_interface.prompt()

        # -- Wait for user input -- 

        @cmd_interface.prompt()

module.exports = CLI