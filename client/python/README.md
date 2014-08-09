# SocialCoffee

SocialCoffee is a Python client library for interacting with Social Coffee service using Thrift protocol. 

## Installation

Add this line to your application's Gemfile:

    $ python setup.py install

## Usage

There are two ways one can interact with the library. 

1. Using `with` statement and explicit nested block.

    ```python
    import socialcoffee

    with socialcoffee.connect(host='localhost', port=9090) as client:
        print(client.ping()) # => "pong"
    ```
    
    The above `with` statement will automatically close connection to remote server after the
    nested block of code. The advantage of using a with statement is that it is guaranteed to 
    close the file no matter how the nested block exits

2. Interaction with `socialcoffee.Client` class

```python
import socialcoffee

try:
    client = socialcoffee.Client(host='localhost', port=9090)
    client.open()
    print(client.ping())
except Thrift.TException as e:
    print(e)
finally:
    client.close()
```

You need to clean up the connection by calling `client.close()`.

## Development

`socialcoffee/client.py` file has an entry point. It is just a stub for future tests.

    $ python socialcoffe/client.py 

    > pong

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
