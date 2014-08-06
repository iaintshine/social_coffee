Environment = require './environment'
KnownPath   = require './known_path'

path    = require 'path'
fs      = require 'fs'
assert  = require 'assert'

yaml    = require 'js-yaml'
logger  = require 'winston'

class Config
    @query_files: ->
        pattern = path.join KnownPath.config, '*.yaml'
        @file_names = fs.readdirSync pattern

    @sanitize: ->
        assert @file_names and @file_names.length > 0, "No configuration files found"
        assert 'db.yaml' in @file_names, "Database configuration file (db.yaml) not found"  

    @load_yaml: (file_name) ->
        file_path = path.join KnownPath.config, file_name
        yaml_content = fs.readFileSync file_path, 'utf8'

        try
            doc = yaml.safeLoad yaml_content 
        catch e
            logger.error e
            logger.error "Failed to parse '#{file_name}' file content"
            process.exit 1    

        assert doc and doc[Environment.current], "Configuration file '#{file_name}' requires '#{Environment.current}' environment configuration to be specified." 
        doc 

    @announce: ->
        for file_name in @file_names
            doc = @load_yaml file_name
            for attribute, v of doc[Environment.current]
                @[attribute] = v 

    @initialize: ->
        @query_files()
        @sanitize()
        @announce()

        
module.export = Config
        