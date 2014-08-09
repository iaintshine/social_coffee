import sys
import contextlib

sys.path.append('gen-py')

from socialcoffee.thrift import SocialCoffeeService
from socialcoffee.thrift.ttypes import *

from thrift import Thrift
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol

class ClientException(Exception):
    pass


class Client(object):
    """A wrapper around the thrift API."""

    def __init__(self, host='localhost', port=9090, timeout=5000):
        """Initialize the SocialCoffee client.

        :parameter host(string): server to connect to. Default- localhost
        :parameter port(int): port to connect to. Default- 9090
        :parameter timeout(int): operation timeout in miliseconds. Default- 5000.

        :return: None

        """

        # Make a socket
        transport = TSocket.TSocket(server, port)
        transport.setTimeout(timeout)

        # Create a buffered transport. Raw sockets are very slow.
        self.__transport = TTransport.TFramedTransport(transport) 

        # Wrap in a protocol
        protocol = TBinaryProtocol.TBinaryProtocol(self.__transport)

        # Create a client to use the protocl encoder.
        self.__client = SocialCoffeeService.Client(protocol)

    def __del__(self):
        self.close()

    def open(self):
        if not self.__clien.isOpen():
            self.__client.open()

    def close(self):
        if self.__client.isOpen():
            self.__client.close()

    def isOpen(self):
        self.__client.isOpen()

    def __getattr__(self, name):
        """
        This is called every time a class method or property is checked and/or called if no class attribute is found.

        Requests are proxied to internal thrift client instance.
        """
        if name in dir(self.__client):
            method = getattr(self.__client, name)
            if callable(method):
                return method
            else:
                raise AttributeError('%s has no moethod name %s' % (self.__client, name))

@contextlib.contextmanager
def connect(host='localhost', port=9090):
    try:
        client = Client(host, port)
        client.open()
        yield client
        client.close()
    except Thrift.TException as e:
        print("Exception occurred during operation", e)

if __name__ == '__main__':
    with connect() as client:
        print(client.ping())

