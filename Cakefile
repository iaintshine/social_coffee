{exec, spawn} = require 'child_process'
{print, puts} = require 'sys'
fs      = require 'fs'
path    = require 'path'

require 'coffee-script'

sys_command = (command, message) ->
    printer = (error, stdout, stderr) ->
        puts message if message
        puts stdout
        puts stderr
    exec command, printer

task 'watch', 'Watch src/ directory for changes', ->
    coffee = spawn 'coffee', ['-w', '-c', '-o', 'lib', 'src']
    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    coffee.stdout.on 'data', (data) ->
        print data.toString()

task 'generate:thrift', 'Generate thrift bindings', ->
    # make sure */lib/thrift*, */doc*, and *doc/thrift* directories exist
    for subdir in ['lib/thrift', 'doc', 'doc/thrift', 'client', 'client/ruby', 'client/python']
        full_path = path.join __dirname, subdir
        fs.mkdirSync full_path unless fs.existsSync full_path

    # generate html documentation
    sys_command 'thrift --gen html -out doc/thrift thrift/social_coffee_service.thrift', 'Generating thrift html documentation ...'

    # generate nodejs bindings
    sys_command 'thrift --gen js:node -out lib/thrift thrift/social_coffee_service.thrift', 'Generating nodejs bindings ...'

    # generate client bindings
    bindings = 
        ruby: 'rb'
        python: 'py'

    for lang, gen of bindings
        sys_command "thrift --gen #{gen} -o client/#{lang} thrift/social_coffee_service.thrift", "Generating #{lang} bindings ..."