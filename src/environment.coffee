class Environment
    @env = process.env.NODE_ENV || 'development'
    @current = @env

    for environment in [ 'development', 'test', 'production', 'staging' ]
        @[environment] = @env is environment

module.exports = Environment