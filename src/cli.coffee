# # Command Line Interface

Thrift = require './thrift/client'
SocialCoffee = require './version'

readline  = require 'readline'
Commander = require 'commander'

# ## Autocompletion

# `Completer` class is used by `readline` interface to Tab autocomplete user input.
class Completer

    COMPLETIONS = 
        friends: ['list']
        friendship: ['create', 'remove']
        quit: []
        ping: []
    
    # The `complete` method is give the current line entered by the user, and returns an array with 
    # two entries. The first is an array with matching entries for the completion. The second one
    # is the substring that was used for the matching.
    #
    # The algorithm if fairly simple. if we see an empty character as the last one in a line than we show
    # all the options for a latest command or all options, if there were no previous command present.
    # If we are in the middle of command typing we filter completion options with those that might contain
    # a substring with current part of the command.
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

# ## Command pattern

# `Command` class is a generic class that represents the command pattern, behavioural design pattern.
# All the commands are constructed by requiring `readline` interface as a context and supports some
# additional helper methods that will be useful in executing command in a later time.  
class Command
    constructor: (context) ->
        @context = context

    prompt: -> @context.prompt()

    # All classes derived from `Command` should implement it's own behaviour by implementing `#execute`
    # method. Default behaviour is to display an array of trimmed client commands. 
    execute: (commands) ->
        console.log commands 


# `QuitCommand` is issued if user writes `quit` command in terminal.
# The command disconnects thrift's client from remote server and close `readline` interface.
class QuitCommand extends Command 

    execute: (commands) ->
        console.log "bye bye ..."
        @context.close()

# `PingCommand` is just a utility command used for asking if we have a connection to remote server.
# The command is issued if user writes `ping` command in terminal. If the client is connected to 
# thrift's server it will respond with `pong` string, displayd in a console.
class PingCommand extends Command 

    execute: (commands) ->
        Thrift.Client.client.ping (err, result) =>
            if err
                console.log "error occurred: " + err.message 
            else
                console.log result
            @prompt()

# `ListFriends` command is issued if user writes `friends list {id}` where an id is user's unique identifier.
# If a user has friends than the list of user's friends IDs is displayed, or empty array otherwise.    
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

# `CreateFriends` command is issued if user writes `friendship create {usera} {userb}` where usera and userb are
# both users ids. The command call displays a message indicating whether or not the operation performed created a new
# friendship relationship or relationship already existed and did nothing. 
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

# `RemoveFriends` comand is issued if user writes `friendship remove {usera} {userb}` where usera and userb are
# both users ids. The command call displays a message indicating whether or not the operation performed removed
# existed friendship relationship or did nothing.
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
 
        # ## CLI Options
        
        # Input arguments are parsed by `Commander` package. It's very easy to use 
        # solution for command - line interfaces. 
        # 
        # `social-cli` command comes with just two options. The first one specifies a port number 
        # and the second one specifies a host to which SocialCoffee thrift client should connect.
        Commander
            .version("Social Coffee v#{SocialCoffee.version} '#{SocialCoffee.codename}'")
            .option('-p, --port <n>', 'Port number', parseInt)
            .option('-h, --host [host]', 'Host number', 'localhost')
            .parse(args)

        # Configure run. Set default values if they were not present in command line call.
        # Default port is `9090` and default host is `localhost`. 

        options = {}
        options['host'] = Commander.host || 'localhost'
        options['port'] = Commander.port || 9090

        # Create `readline` interface instance. 

        cmd_options = 
            input: process.stdin
            output: process.stdout
            completer: @completer.complete

        @cmd_interface = readline.createInterface cmd_options

        # We set the prompt to value in form `host:port>`. 
        # If we consider the case where no parameters were specified than we can expect
        # the prompt in form
        # ```
        #   localhost:9090>
        # ```

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

         # Connect to thrift server

        Thrift.Client.connect options.host, options.port, =>
            @cmd_interface.prompt()

        # Wait for user input 

        @cmd_interface.prompt()

module.exports = CLI