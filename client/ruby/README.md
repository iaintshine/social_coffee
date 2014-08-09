# SocialCoffee

SocialCoffee is a Ruby client library for interacting with Social Coffee service using Thrift protocol. 

## Installation

Add this line to your application's Gemfile:

    gem "social_coffee", git: "https://github.com/iaintshine/social_coffee/client/ruby"

And then execute:

    $ bundle

## Usage

There are two ways one can interact with the library. 

1. Using connection helper with explicit block parameter

```ruby
SocialCoffee.connect host, port do |client|
    client.get_friends user_a # => [user_b]
end
```

Notice that connection is cleaned up after the block.

2. Interaction with `SocialCoffee::Client` instance

```ruby
begin
    client = SocialCoffee.connect host: host, port: port, timeout: 5.seconds
    client.open

    client.get_friends user_a # => [user_b]
rescue => e
    puts e
ensure
    client.close
end
```

You need to clean up the connection by calling `client.close`.

For more information take a look under `spec` directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request