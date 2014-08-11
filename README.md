# Social Coffee

*Social Coffee* is a Thrift service used for querying friendships and user's relationships.
It is written in Node.js using Coffeescript and stores data in Redis key-value NoSQL store. 
Comes with client libraries written for Python, Ruby and Node. In addition to multiple client libraries 
it comes with `social-cli` - interactive command utility. 

## Goals

It supports very simple operations and tries to solve very few problems, but it's designed for on-line, low-latency 
and high-throughput.

* a high rate of query/add/remove operations
* potentially complex *set* arithmentic operations
* horizontal scaling
* sharding
* consistent

## Non - goals

* multi-hop or graph-walking queries

## Operations

The service supports fairly simple operations and it's used to store a symmetrical social graph, where if a user A is a friend with a user B, then symmetrically a user B is a friend with a user A. For each friendship relationship operation there are two rows written into the backing store. 

```
users:1:friends -> [ 2 ]
users:2:friends -> [ 1 ] 
```

1. Query friends list.
    
    Synopsis:
    ```
    list<ID> get_friends(1: ID id) throws (1: SocialException ex)
    ```

    Returns a list of user's friends with provided ID. 

    Params: 
    * `id` - The ID of the user for whom the list of the friends should be retrieved.

    Return:
    * The list of user's friends IDs. If user has no friends empty list is returned.

    Throws:
    `SocialException` if
    * ID is null
    * ID is not a number
    * ID is a non positive number
    * internall error occurs, e.g. connection to a database could not be established

    Example:
    ```ruby
    client.get_friends 1
    ```

2. Create friendship between two users
    
    Synopsis:
    ```
    bool create_friendship(1: ID usera, 2: ID userb) throws (1: SocialException ex)
    ```

    Asks the service to make a new multual friendship relationship between users with IDs usera and userb.
    It's an idempotent operation so it can be called multiple times.

    Params: 
    * `usera` - The ID of the user A.
    * `userb` - The ID of the user B.

    Return:
    * Boolean value indicating whether the operation created a new relationship or relationship already existed. "true" if operation created a new friendship relationship, "false" otherwise.

    Throws:
    `SocialException` if
    * any of IDs is null
    * any of IDs is not a number
    * any of IDs is a non positive number
    * both of IDs are equal
    * internall error occurs, e.g. connection to a database could not be established

    Example:
    ```ruby
    client.create_friendship 1, 2
    ```

3. Remove friendship between two users
    
    Synopsis:
    ```
    bool remove_friendship(1: ID usera, 2: ID userb) throws (1: SocialException ex)
    ```

    Asks the service to remove a new friendship relationship between users with IDs usera and userb.
    It's an idempotent operation so it can be called multiple times.

    Params: 
    * `usera` - The ID of the user A.
    * `userb` - The ID of the user B.

    Return:
    * Boolean value indicating whether the operation removed an already existed relationship or operation did nothing. "true" if operation removed an already existed friendship relationship, "false" otherwise.

    Throws:
    `SocialException` if
    * any of IDs is null
    * any of IDs is not a number
    * any of IDs is a non positive number
    * both of IDs are equal
    * internall error occurs, e.g. connection to a database could not be established

    Example:
    ```ruby
    client.remove_friendship 1, 2
    ```

## Installation

### Runtime Requirements

To operate properly Social Coffee service requires

* `Node.js` platform
* and access to `Redis` key-value data store

### Service Requirements

Installation of server's required packages is as simple as calling

    $ npm install

## Running

### Configuration

All required configuration files are found under `config/` directory and use YAML format. For now there is only a single configuration file required called `db.yaml`. 

`db.yaml` contains a database configuration (here Redis) for every runtime environment (e.g. development, test, production, staging). If redis is installed on a `localhost` with default configuration creating database configuration file is as simple as calling:

    $ cp config/db.yaml.example config/db.yaml

Parameters:
* `host`, string, required, URL of the host machine where Redis is installed
* `port`, number, required, the port number of a Redis instance
* `password`, string, optional, if a Redis instance is password-protected, password required for authentication

### Starting the Server

By default the server ships with four enviornments: "development", "test", "staging" and "production".
If no environment is specified the server starts in development environemnt. So calling:

    $ node lib/index.js

starts the server bound to host `0.0.0.0`, port `9090` and in `development` environment.
To change an environemnt use `NODE_ENV` environment variable. E.g. to start the server in `production` enviornment on port `3000` execute:
    
    $ NODE_ENV=production node lib/index.js -p 3000

Options:

* `-p`, `--port`, `number`, default: `9090`, the port number

## CLI

*Social Coffee* service is delivered with a command line tool similar `redis-cli` that works in REPL manner.
`social-cli` supports tab autocompletion and comes with just two options. The first one specifies a port number 
and the second one specifies a host to which thrift client should connect.

### Options

* `-p`, `--port`, `number`, default: `9090`, port number
* `-h`, `--hort`, `string`, default: `localhost`, host address

### Command list

* `ping` - utility command used for asking if we still have a connection to a remote server. If the client is connected to 
thrift's server it will respond with `"pong"` string, displayd in a console.
* `server info` - the command asks a remote server for thrift server description.
* `server counters` - the command asks a remote server for performance counters.
* `server options` - the command asks a remote server for server options/configuration.
* `friends list id` - the command queries a remote server for user's friends list. If a user has friends than the list of user's friends IDs is displayed, empty array otherwise. 
* `friendship create id_a id_b` - the command asks a remote server to make a new mutual friendship relationship between users with IDs `id_a` and `id_b`. The command call displays a message indicating whether or not the operation performed created a new
friendship relationship or relationship already existed and did nothing. 
* `friendship remove id_a id_b` - the command asks a remote server to remove a friendship relationship between users with IDs `id_a` and `id_b`. The command call displays a message indicating whether or not the operation performed removed existed friendship relationship or did nothing.
* `quit`, `exit` - the command disconnects thrift's client from remote server and shuts down cli.

### Sample session

Below code shows a sample session from interaction with `social-cli` command line tool.
 
```
localhost:9000>info: client connected to remote server
localhost:9000>ping
pong
localhost:9000>friends list 1
[]
localhost:9000>friendship create 1 2
friendship newely created: true
localhost:9000>friends list 1
[ 2 ]
localhost:9000>friendship remove 1 2
friendship just removed: true
localhost:9000>friends list 1
[]
localhost:9000>quit
bye bye...
```  

## Clients

The sever except for `social-cli` command line tool comes with multiple client libraries written for Python, Ruby and Node.js (using Coffeescript).

### Ruby

See [the offical Social Coffee Ruby client documentation](https://github.com/iaintshine/social_coffee/tree/master/client/ruby)

### Python

See [the offical Social Coffee Python client documentation](https://github.com/iaintshine/social_coffee/tree/master/client/python)

### Node.js

It is not exposed as a package but instead used internally by the `social-cli` command line tool. 

* [Client definition](https://github.com/iaintshine/social_coffee/blob/master/src/thrift/client.coffee)
* [Client usage](https://github.com/iaintshine/social_coffee/blob/master/src/cli.coffee)

## Testing

### Unit Testing

To run unit tests execute:

    $ npm test

### Load Testing

For more information about how to load test the thrift service using Locust see [load testing](https://github.com/iaintshine/social_coffee/tree/master/locust)

## Development

### Requirements

1. Globally install Coffeescript compiler

        $ [sudo] npm install -g coffeescript

2. Globally install Cake

        $ [sudo] npm install -g cake

3. If you are going to generate documentation, globally install groc

        $ [sudo] npm install -g groc

4. If you are going to regenerate and change thrift interfaces install Thrift compiler with support for at least Node.js, Ruby and Python. [Apache Thrift](https://thrift.apache.org)  

Now if all the above requirements are installed execute `watch` cake task to watch `src/` directory for changes and compile `*.coffee` files into `*.js` equivalent.

        $ cake watch  

### Cake Tasks

* `watch` - the task used for watching for Coffeescript file changes and recompilation to Javascript. 
* `generate:thrift` - the task used for generating thrift bindings for Node.js, Python, Ruby and human-readable HTML documentation generation from thrift interfaces stored under `thrift/` directory.

E.g. to regenerate thrift bindings simply call:

    $ cake generate:thrift 

## Provisioning

For more information about how to provision the service using Ansible see [provision](https://github.com/iaintshine/social_coffee/tree/master/provision)


## What's missing

* Server Clustering
* Redis Automatic failover with sentinel
* Database model support for replication with master/multiple slaves
* Multiple Redis instances sharding
* Distributed transactions support with Two-phase Commit Protocol. Instead of writing a coordinator to handle distributed transactions we might choose to use e.g. Hyperdex data store which supports distirbuted transactions with it's own WARP protocol. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request