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

    ```ruby
    client.get_friends 1
    ```


2. Create friendship between two users

3. Remove friendship between two users

## Installation

    npm install

## Requirements

## Configuration

## Running
  
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

## Development Requirements

* Globally installed Coffeescript compiler

    [sudo] npm install -g coffeescript

* Globally installed Cake

    [sudo] npm install -g cake

## Testing

## Load Testing

For more information about how to load test the thrift service using Locust see [load testing](https://github.com/iaintshine/social_coffee/tree/master/locust)

## Development

    npm test

## Provisioning

For more information about how to provision the service using Ansible see [provision](https://github.com/iaintshine/social_coffee/tree/master/provision)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request