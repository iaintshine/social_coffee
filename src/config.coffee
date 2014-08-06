Environment = require './environment'
KnownPath   = require './known_path'

path    = require 'path'
fs      = require 'fs'
assert  = require 'assert'

yaml    = require 'js-yaml'
logger  = require 'winston'

class Config
    @query_files: ->
        all_file_names = fs.readdirSync KnownPath.config
        @file_names = all_file_names.filter (file_name) -> file_name.match(/\S*.yaml$/i)

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

    # here we announce (make it public) configuration for current running environment for every
    # found configuration file. E.g. if we find db.yaml file one can ask Config.db.{attribute} for 
    # attribute of database configuration. 
    @announce: ->
        for file_name in @file_names
            logger.info "Processing configuration file '#{file_name}'"

            doc = @load_yaml file_name
            base_name = path.basename file_name, '.yaml'
            logger.info "One can access configuration of '#{file_name}' with 'Config.#{base_name}' syntax."

            @[base_name] = doc[Environment.current]

    @initialize: ->
        @query_files()
        @sanitize()
        @announce()

        
module.exports = Config
        