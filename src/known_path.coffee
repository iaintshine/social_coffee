path = require 'path'

class KnownPath
    @root = path.join __dirname, '..'

    for subpath in ['bin', 'config', 'node_modules', 'src', 'log', 'test', 'tmp']
        @[subpath] = path.join @root, subpath

    @pids = path.join @tmp, 'pids'

module.exports = KnownPath