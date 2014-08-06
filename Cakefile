{spawn} = require 'child_process'
{print} = require 'sys'

require 'coffee-script'

task 'watch', 'Watch src/ directory for changes', ->
    coffee = spawn 'coffee', ['-w', '-c', '-o', 'lib', 'src']
    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    coffee.stdout.on 'data', (data) ->
        print data.toString()