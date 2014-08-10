# Locust

Locust is an open source load testing tool. Even though locuss was built with HTTP in mind, it is
very extendable and allows to test any request/response based system - here Thrift.

## Installation

The easiest way to install Locust is using pip:

    $ pip install locustio

## Testing

Make sure to first provision the server using `provision` script or change the `host` variable under `locustfile.py` at line `72`
to `localhost` or any other host where social coffee thrift server is running.

To run Locust (if we are in the local locust directory) it's as simple as calling

    $ locust

Now open up a browser and point to `http://127.0.0.1:8089`